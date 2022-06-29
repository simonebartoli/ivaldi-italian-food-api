import {Args, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {Item} from "../types/itemType";
import {PaginationInterface} from "../args/paginationInterface";
import {CursorInterface} from "../args/cursorInterface";
import {GetItemsArgs} from "../args/getItemsArgs";

@Resolver()
export class ItemResolvers {

    @Query(returns => [Item])
    async getItems_FULL(@Args() options: GetItemsArgs): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false, filter} = options
        const {categories} = filter || {} // TO DO
        const {max, min} = priceRange || {}

        return await prisma.items.findMany({
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price: {
                    gte: min,
                    lte: max
                }
            }
        })
    }

    @Query(returns => [Item])
    async getItems_pagination(@Args() {limit, offset}: PaginationInterface, @Args() options: GetItemsArgs): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false} = options
        const {max, min} = priceRange || {}

        return await prisma.items.findMany({
            skip: offset,
            take: limit,
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price: {
                    gte: min,
                    lte: max
                }
            }
        })
    }

    @Query(returns => [Item])
    async getItems_cursor(@Args() {cursor, limit}: CursorInterface, @Args() options: GetItemsArgs): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false} = options
        const {max, min} = priceRange || {}

        if(cursor === undefined || cursor === null){
            return await prisma.items.findMany({
                take: limit,
                where: {
                    NOT: {
                        discount_id: !discountOnly ? undefined : null
                    },
                    amount_available: {
                        gte: outOfStock ? 0 : 1
                    },
                    price: {
                        gte: min,
                        lte: max
                    }
                }
            })
        }
        return await prisma.items.findMany({
            cursor: {
                item_id: cursor
            },
            skip: 1,
            take: limit,
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price: {
                    gte: min,
                    lte: max
                }
            }
        })
    }

}