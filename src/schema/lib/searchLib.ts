import {Context} from "../types/not-graphql/contextType";

export type SearchResult = Map <number, number>

export const searchProducts = async (keywordsString: string, ctx: Context): Promise<SearchResult> => {
    const {redis} = ctx
    const MAX_ACCURACY = 100
    // const OVERALL_MIN_ACCURACY = 80
    const SINGLE_MIN_ACCURACY = 25

    const keywords = keywordsString.split(" ").filter(element => element.length > 2)

    let itemsMap = new Map()
    const KEY_ACCURACY = MAX_ACCURACY / keywords.length

    let CURRENT_ACCURACY = 0
    for(const keyword of keywords){
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
        }
    }
    let items: SearchResult = new Map()
    itemsMap.forEach((value, key) => {
        if(value >= SINGLE_MIN_ACCURACY){
            items.set(parseInt(key), parseFloat(value))
        }
    })

    return items
}