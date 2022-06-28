import prisma from "../src/db/prisma";

export const addDiscountsToItems = async () => {
    const discountBeingNull = 65
    const discountsID: number[] = []
    const itemsID: number[] = []

    const discounts = await prisma.discounts.findMany({select: {discount_id: true}})
    const items = await prisma.items.findMany({select: {item_id: true}})

    const discountLength = discounts.length

    for(const discount of discounts){
        discountsID.push(discount.discount_id)
    }
    for(const item of items){
        itemsID.push(item.item_id)
    }

    await prisma.$transaction(async (prisma) => {
        for(const itemID of itemsID){
            const randomNumber = Math.floor(Math.random() * 100) + 1
            const nullValue = randomNumber <= discountBeingNull
            const valueToInsert = nullValue ? null : discountsID[Math.floor(Math.random() * discountLength)]
            await prisma.items.update({
                where: {
                    item_id: itemID
                },
                data: {
                    discount_id: valueToInsert
                }
            })
        }
    })



}