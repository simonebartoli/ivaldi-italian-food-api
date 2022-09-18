import prisma from "../db/prisma";
import {redisClient, redisType} from "../db/redis";

const initRedis = async (client: redisType) => {
    redisClient.on('error', (err) => console.log('Redis Client Error', err));
    await redisClient.connect();
    const keywords = await prisma.keywords.findMany()
    for(const keyword of keywords){
        await client.SADD(keyword.keyword, keyword.item_id.toString())
    }

    const categories = await prisma.categories.findMany({
        include: {
            sub_categories: {
                include: {
                    sub_categories_items: true
                }
            },
            categories_items: true
        }
    })
    for(const cat of categories){
        for(const catOnly of cat.categories_items){
            await client.SADD(cat.name.toLowerCase(), String(catOnly.item_id))
        }
        if(cat.sub_categories.length !== 0){
            for(const subCat of cat.sub_categories){
                for(const subCatItem of subCat.sub_categories_items){
                    await client.SADD(cat.name.toLowerCase(), String(subCatItem.item_id))
                    await client.SADD(subCat.name.toLowerCase(), String(subCatItem.item_id))
                }
            }
        }
    }
}

initRedis(redisClient)
    .then(() => {
        console.log("OK")
        process.exit(0)
    })
    .catch((e) => {
        console.log(e)
        process.exit(1)
    })