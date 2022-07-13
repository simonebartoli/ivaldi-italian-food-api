import prisma from "../db/prisma";
import {redisType} from "../db/redis";

export const initRedis = async (client: redisType) => {
    // const keywords = await prisma.keywords.findMany()
    // for(const keyword of keywords){
    //     await client.SADD(keyword.keyword, keyword.item_id.toString())
    // }
}