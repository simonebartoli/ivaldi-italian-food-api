import prisma from "../src/db/prisma";

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