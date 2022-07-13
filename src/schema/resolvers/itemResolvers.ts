import {Arg, Args, Ctx, Int, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {Item} from "../types/itemType";
import {PaginationInterface} from "../args/paginationInterface";
import {CursorInterface} from "../args/cursorInterface";
import {GetItemsArgs} from "../args/getItemsArgs";
import {searchProducts, SearchResult} from "../lib/searchLib";
import {Context} from "../types/not-graphql/contextType";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";

@Resolver()
export class ItemResolvers {

    @Query(returns => Item)
    async getItem(@Arg("id", type => Int) id: number): Promise<Item> {
        const result = await prisma.items.findUnique({
            where: {
                item_id: id
            }
        })
        if(result === null) throw new DATA_ERROR("Item Not Existing", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
        return result
    }


    @Query(returns => [Item])
    async getItems_FULL(@Args() options: GetItemsArgs, @Ctx() ctx: Context): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false, keywords} = options
        const {max, min} = priceRange || {}

        let products: SearchResult | undefined = keywords !== undefined ? await searchProducts(keywords, ctx) : undefined
        const productsID = products !== undefined ? [...products.keys()] : undefined

        const result = await prisma.items.findMany({
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                item_id: {
                  in: productsID
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price_total: {
                    gte: min,
                    lte: max
                }
            }
        })
        return result.map((element) => {
            return {
                ...element,
                importance: products?.get(element.item_id)
            }
        })
    }

    @Query(returns => [Item])
    async getItems_pagination(@Args() {limit, offset}: PaginationInterface, @Args() options: GetItemsArgs, @Ctx() ctx: Context): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false, keywords} = options
        const {max, min} = priceRange || {}

        let products: SearchResult | undefined = keywords !== undefined ? await searchProducts(keywords, ctx) : undefined
        const productsID = products !== undefined ? [...products.keys()] : undefined

        return await prisma.items.findMany({
            skip: offset,
            take: limit,
            where: {
                NOT: {
                    discount_id: !discountOnly ? undefined : null
                },
                item_id: {
                    in: productsID
                },
                amount_available: {
                    gte: outOfStock ? 0 : 1
                },
                price_total: {
                    gte: min,
                    lte: max
                }
            }
        })
    }

    @Query(returns => [Item])
    async getItems_cursor(@Args() {cursor, limit}: CursorInterface, @Args() options: GetItemsArgs, @Ctx() ctx: Context): Promise<Item[]>{
        const {discountOnly = false, priceRange, outOfStock = false, keywords} = options
        const {max, min} = priceRange || {}

        let products: SearchResult | undefined = keywords !== undefined ? await searchProducts(keywords, ctx) : undefined
        const productsID = products !== undefined ? [...products.keys()] : undefined

        if(cursor === undefined || cursor === null){
            return await prisma.items.findMany({
                take: limit,
                where: {
                    NOT: {
                        discount_id: !discountOnly ? undefined : null
                    },
                    item_id: {
                        in: productsID
                    },
                    amount_available: {
                        gte: outOfStock ? 0 : 1
                    },
                    price_total: {
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
                price_total: {
                    gte: min,
                    lte: max
                }
            }
        })
    }

}