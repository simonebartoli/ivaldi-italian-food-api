import prisma from "../src/db/prisma";

export const initWeight = async () => {
    const itemInGrams = await prisma.items.findMany({
        select: {
            item_id: true,
            price_unit: true
        },
        where: {
            price_unit: {
                endsWith: "g"
            }
        }
    })
    const itemInKilograms = await prisma.items.findMany({
        select: {
            item_id: true,
            price_unit: true
        },
        where: {
            price_unit: {
                endsWith: "kg"
            }
        }
    })
    const itemInMillilitres = await prisma.items.findMany({
        select: {
            item_id: true,
            price_unit: true
        },
        where: {
            price_unit: {
                endsWith: "ml"
            }
        }
    })

    await prisma.$transaction(async (prisma) => {
        for(const item of itemInGrams){
            const grams = item.price_unit.split("g")[0]
            if(grams){
                await prisma.items.update({
                    where: {
                        item_id: item.item_id
                    },
                    data: {
                        weight: parseInt(grams)
                    }
                })
            }
        }
        for(const item of itemInMillilitres){
            const grams = item.price_unit.split("ml")[0]
            if(grams){
                await prisma.items.update({
                    where: {
                        item_id: item.item_id
                    },
                    data: {
                        weight: parseInt(grams)
                    }
                })
            }
        }
        for(const item of itemInKilograms){
            let grams = item.price_unit.split("kg")[0]
            if(grams){
                grams = grams + "000"
                await prisma.items.update({
                    where: {
                        item_id: item.item_id
                    },
                    data: {
                        weight: parseInt(grams)
                    }
                })
            }
        }
    })
}