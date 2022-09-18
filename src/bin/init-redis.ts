import prisma from "../db/prisma";
import {redisClient, redisType} from "../db/redis";

const initRedis = async (client: redisType) => {
    redisClient.on('error', (err) => console.log('Redis Client Error', err));
    await redisClient.connect();
    const keywords = await prisma.keywords.findMany()
    for(const keyword of keywords){
        await client.SADD(keyword.keyword, keyword.item_id.toString())
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