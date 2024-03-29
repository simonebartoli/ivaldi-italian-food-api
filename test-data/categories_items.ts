import prisma from "../src/db/prisma";
import {redisClient} from "../src/db/redis";

export const addCategoriesSubCategoriesToItems = async () => {
    const items = await prisma.items.findMany({select: {item_id: true}})
    const subCategories = await prisma.sub_categories.findMany({select: {sub_category_id: true}})
    const categoriesWithNoSub: any[] = await prisma.$queryRaw`SELECT categories.category_id FROM categories LEFT JOIN sub_categories sc on categories.category_id = sc.category_id WHERE sc.category_id IS NULL`

    const minCategories = 1
    const maxCategories = 5

    await prisma.$transaction(async (prisma) => {
        for(const item of items){
            const numberOfCategories = Math.floor(Math.random() * maxCategories) + minCategories
            const percentageCategoriesWithNoSub = Math.floor(100 / (subCategories.length + categoriesWithNoSub.length) * categoriesWithNoSub.length)

            const categoriesAlreadyUsed: number[] = []
            const subCategoriesAlreadyUsed: number[] = []

            for(let i=0; i<numberOfCategories; i++){
                const includeCategory: boolean = Math.floor(Math.random() * 100) < percentageCategoriesWithNoSub
                if(includeCategory){
                    let index
                    let error = 0
                    do{
                        error ++
                        index = Math.floor(Math.random() * categoriesWithNoSub.length)
                    }while (categoriesAlreadyUsed.includes(index) && error < 3)

                    if(error >= 3){
                        continue
                    }
                    categoriesAlreadyUsed.push(index)
                    const valueChosen = categoriesWithNoSub[index].category_id
                    await prisma.categories_items.create({
                        data: {
                            category_id: valueChosen,
                            item_id: item.item_id
                        }
                    })
                }else{
                    let index
                    let error = 0
                    do{
                        error ++
                        index = Math.floor(Math.random() * subCategories.length)
                    }while (subCategoriesAlreadyUsed.includes(index) && error < 3)

                    if(error >= 3){
                        continue
                    }
                    subCategoriesAlreadyUsed.push(index)
                    const valueChosen = subCategories[index]!.sub_category_id
                    await prisma.sub_categories_items.create({
                        data: {
                            sub_category_id: valueChosen,
                            item_id: item.item_id
                        }
                    })

                }
            }

        }
    })
}


export const addCategoriesSubCategoriesToRedis = async () => {
    let categoryFinal: {
        name: string
        id: number[]
    }[] = []

    const itemCategories = await prisma.categories.findMany({
        select: {
            name: true,
            sub_categories: {
              select: {
                  sub_categories_items: {
                      select: {
                          item_id: true
                      }
                  }
              }
            },
            categories_items: {
                select: {
                    item_id: true
                }
            }
        }
    })

    const itemSubCategories = await prisma.sub_categories.findMany({
        select: {
            name: true,
            sub_categories_items: {
                select: {
                    item_id: true
                }
            }
        }
    })

    for(const element of itemCategories) {
        const finalID: number[] = []
        for(const subElement of element.categories_items){
            finalID.push(subElement.item_id)
        }
        for(const subElement of element.sub_categories){
            for(const subSubElement of subElement.sub_categories_items){
                finalID.push(subSubElement.item_id)
            }
        }
        categoryFinal.push({
            name: element.name,
            id: finalID
        })
    }

    for(const element of itemSubCategories){
        const finalID: number[] = []

        for(const subElement of element.sub_categories_items){
            finalID.push(subElement.item_id)
        }
        categoryFinal.push({
            name: element.name,
            id: finalID
        })
    }
    await redisClient.connect()
    for(const element of categoryFinal){
        for(const subElement of element.id){
            await redisClient.SADD(element.name, subElement.toString())
        }
    }
    console.log(categoryFinal)
}