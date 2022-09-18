import {Context} from "../types/not-graphql/contextType";
import {distance} from "fastest-levenshtein";

export type SearchResult = Map <number, number>

export const searchProducts = async (keywordsString: string, ctx: Context): Promise<SearchResult> => {
    const {redis} = ctx
    const MAX_ACCURACY = 100
    const OVERALL_MIN_ACCURACY = 75
    const SINGLE_MIN_ACCURACY = 25

    console.time("FUNCTION")
    const keywordsPassed = keywordsString.split(" ").filter(element => element.length > 2).map((element) => element.toLowerCase())
    let keywordsNotFound: string[] = []
    const keywordsAlias: string[] = []

    let itemsMap = new Map()
    const KEY_ACCURACY = MAX_ACCURACY / keywordsPassed.length

    let CURRENT_ACCURACY = 0
    for(const keyword of keywordsPassed){
        if(await redis.EXISTS(keyword) === 1){
            const result = await redis.SMEMBERS(keyword)
            for(const keyFound of result){
                const item = itemsMap.get(keyFound)
                if(item !== undefined){
                    itemsMap.set(keyFound, item+KEY_ACCURACY)
                }else{
                    itemsMap.set(keyFound, KEY_ACCURACY)
                }
            }
            CURRENT_ACCURACY += KEY_ACCURACY
        }else{
            keywordsNotFound.push(keyword)
        }
    }

    if(CURRENT_ACCURACY < OVERALL_MIN_ACCURACY){
        console.time("CHECK FURTHER KEYS")
        const keywordsNotFoundFinal: string[] = []
        for(const keywordNotFound of keywordsNotFound){
            const result = await redis.EXISTS(`keyword_alias@${keywordNotFound}`)
            if(result === 0) keywordsNotFoundFinal.push(keywordNotFound)
            else{
                const members = await redis.SMEMBERS(`keyword_alias@${keywordNotFound}`)
                for(const key of members){
                    keywordsAlias.push(key)
                }
                CURRENT_ACCURACY += KEY_ACCURACY
            }
        }
        const keywordNotFoundFinalLowLevel = []
        const redisKeys = await redis.KEYS("*")
        if(CURRENT_ACCURACY < OVERALL_MIN_ACCURACY){
            for(const keywordNotFound of keywordsNotFoundFinal){
                const keysToCheck = redisKeys.filter((element) => {
                    return element.length >= keywordNotFound.length - 2 && element.length <= keywordNotFound.length + 2;
                })
                for(const keyToCheck of keysToCheck) {
                    if(distance(keywordNotFound, keyToCheck) <= 2){
                        await redis.SADD(`keyword_alias@${keywordNotFound}`, keyToCheck)
                        await redis.EXPIRE(`keyword_alias@${keywordNotFound}`, 3600)
                        keywordsAlias.push(keyToCheck)
                    }else{
                        keywordNotFoundFinalLowLevel.push(keywordNotFound)
                    }
                }
            }
        }
        if(CURRENT_ACCURACY < OVERALL_MIN_ACCURACY) {
            for(const keyNotFound of keywordNotFoundFinalLowLevel){
                const result = redisKeys.filter((_) => _.includes(keyNotFound))
                for(const element of result) keywordsAlias.push(element)
            }
        }
        console.timeEnd("CHECK FURTHER KEYS")
    }

    if(keywordsAlias.length > 0){
        for(const keyword of keywordsAlias){
            const result = await redis.SMEMBERS(keyword)
            for(const keyFound of result){
                const item = itemsMap.get(keyFound)
                if(item !== undefined){
                    itemsMap.set(keyFound, item+KEY_ACCURACY)
                }else{
                    itemsMap.set(keyFound, KEY_ACCURACY)
                }
            }
        }
    }

    let items: SearchResult = new Map()
    itemsMap.forEach((value, key) => {
        if(value >= SINGLE_MIN_ACCURACY){
            items.set(parseInt(key), parseFloat(value))
        }
    })
    console.timeEnd("FUNCTION")
    return items
}
