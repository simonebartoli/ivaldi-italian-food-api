import prisma from "../src/db/prisma";
import fs from "fs";

export const addKeywordsToItem = async () => {
    const MIN_KEYWORDS = 5
    const MAX_KEYWORDS = 15

    const items = await prisma.items.findMany()
    const keywords: string[] = JSON.parse(fs.readFileSync(process.cwd() + "/csv/keywords.json").toString())
    let finalKeywords: string[] = []
    for(const key of keywords){
        finalKeywords = [
            ...finalKeywords,
            ...key.split(" ")
        ]
    }

    await prisma.$transaction(async (prisma) => {
        for(const item of items){
            const numOfKeywords = Math.floor(Math.random() * MAX_KEYWORDS) + MIN_KEYWORDS
            const keywordsUsed: string[] = []
            for(let i = 0; i < numOfKeywords; i++){
                let keyword = ""
                do{
                    keyword = finalKeywords[Math.floor(Math.random() * finalKeywords.length)] as string
                }while (keywordsUsed.includes(keyword))

                keywordsUsed.push(keyword)
                await prisma.keywords.create({
                    data: {
                        item_id: item.item_id,
                        keyword: keyword
                    }
                })
            }
        }
    })

}