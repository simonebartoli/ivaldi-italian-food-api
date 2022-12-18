import prisma from "../src/db/prisma";

export const initWeight = async () => {
    const itemInGrams = await prisma.items.findMany({
        select: {
            item_id: true,
            price_unit: true
        },
        where: {
            price_unit: {
                mode: "insensitive",
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
                mode: "insensitive",
                endsWith: "ml"
            }
        }
    })
    const itemInCl = await prisma.items.findMany({
        select: {
            item_id: true,
            price_unit: true
        },
        where: {
            price_unit: {
                endsWith: "cl"
            }
        }
    })

    await prisma.$transaction(async (prisma) => {
        for(const item of itemInGrams){
            let grams = item.price_unit.split("g")[0]
            if(grams === undefined){
                grams = item.price_unit.split("G")[0]
            }
            if(grams!.split("x").length > 1){
                grams = String(Number(grams!.split("x")[0]!) * Number(grams!.split("x")[1]!))
            }
            if(grams!.split("X").length > 1){
                grams = String(Number(grams!.split("X")[0]!) * Number(grams!.split("X")[1]!))
            }
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
            let grams = item.price_unit.split("ml")[0]
            if(grams === undefined){
                grams = item.price_unit.split("ML")[0]
            }
            if(grams!.split("x").length > 1){
                grams = String(Number(grams!.split("x")[0]!) * Number(grams!.split("x")[1]!))
            }
            if(grams!.split("X").length > 1){
                grams = String(Number(grams!.split("X")[0]!) * Number(grams!.split("X")[1]!))
            }
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
        for(const item of itemInCl){
            let grams = item.price_unit.split("cl")[0]
            if(grams!.split("x").length > 1){
                grams = String(Number(grams!.split("x")[0]!) * Number(grams!.split("x")[1]!))
            }
            if(grams){
                grams = grams + "0"
                console.log(grams)
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