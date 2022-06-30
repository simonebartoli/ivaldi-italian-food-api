import prisma from "../src/db/prisma";
import {Item} from "../src/schema/types/itemType";
import {ArchiveItem} from "../src/schema/types/archiveItemType";
import {Vat} from "../src/schema/types/vatType";
import {DateTime} from "luxon";

export const addOrders = async () => {
    const MIN_ORDERS = 2
    const MAX_ORDERS = 6
    const MIN_ITEMS = 3
    const MAX_ITEMS = 10
    const MIN_AMOUNT = 1
    const MAX_AMOUNT = 4
    const MIN_SHIPPING_COST = 0
    const MAX_SHIPPING_COST = 5

    const users = await prisma.users.findMany()
    const items = await prisma.items.findMany({
        include: {
            vat: true
        }
    })

    prisma.$transaction(async (prisma) => {
        for(const user of users){
            const numberOrOrders = Math.floor(Math.random() * MAX_ORDERS) + MIN_ORDERS

            for(let i = 0; i< numberOrOrders; i++){
                const itemsAlreadyUsed: number[] = []
                const itemNumberChosen = Math.floor(Math.random() * MIN_ITEMS) + MAX_ITEMS
                const shippingCost = parseFloat((Math.random() * MAX_SHIPPING_COST + MIN_SHIPPING_COST).toFixed(2))
                const datetime = DateTime.now().toISO()
                const userID = user.user_id

                const statusProbability = Math.random()
                const status =
                    statusProbability < 1/2 ? "PENDING"
                        : statusProbability >= 1/2 && statusProbability < 5/6 ? "DELIVERED" : "CANCELLED"

                let archive: ArchiveItem[] = []
                let priceTotal: number = 0

                for(let j = 0; j < itemNumberChosen; j++){
                    let itemChosen: Item & {vat: Vat}
                    do{
                        itemChosen = items[Math.floor(Math.random() * items.length)]!
                    }while (itemsAlreadyUsed.includes(itemChosen.item_id))
                    itemsAlreadyUsed.push(itemChosen.item_id)

                    const amount = Math.floor(Math.random() * MAX_AMOUNT) + MIN_AMOUNT
                    archive.push({
                        name: itemChosen.name,
                        amount: amount,
                        price_per_unit: itemChosen.price_total,
                        price_unit: itemChosen.price_unit,
                        price_total: parseFloat((itemChosen.price_total * amount).toFixed(2)),
                        vat: itemChosen.vat.percentage
                    })
                    priceTotal += itemChosen.price_total * amount
                }

                await prisma.orders.create({
                    data: {
                        price_total: parseFloat(priceTotal.toFixed(2)),
                        shipping_cost: shippingCost,
                        datetime: datetime,
                        status: status,
                        archive: JSON.stringify(archive),
                        user_id: userID
                    }
                })
            }
        }
    })
}