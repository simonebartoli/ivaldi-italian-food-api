import {Arg, Ctx, Query, Resolver} from "type-graphql";
import {Order} from "../types/orderType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {Context} from "../types/not-graphql/contextType";
import prisma from "../../db/prisma";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";
import {OrderReceiptFilters} from "../inputs/orderReceiptFilters";

@Resolver()
export class OrderResolver {

    // RESOLVER CUSTOM FOR ARCHIVE ITEMS

    @Query(returns => [Order])
    @RequireValidAccessToken()
    async getOrders_FULL(@Ctx() ctx: Context, @Arg("filters", type => OrderReceiptFilters) filters: OrderReceiptFilters): Promise<Order[]> {
        const {user_id} = ctx
        const {priceMin, priceMax, dateMin, dateMax, order_ref} = filters
        const result = await prisma.orders.findMany({
            where: {
                reference: order_ref,
                user_id: user_id!,
                status: {
                    not: {
                        in: ["REQUIRES_PAYMENT", "CANCELLED"]
                    }
                },
                price_total: {
                    gte: priceMin,
                    lte: priceMax
                },
                datetime: {
                    gte: dateMin,
                    lte: dateMax
                }
            },
            orderBy: {
                datetime: "desc"
            }
        })
        return result.map((element) => {
            return {
                ...element,
                status: element.status as ORDER_STATUS_ENUM,
                archive: JSON.parse(element.archive)
            }
        })

    }

}