import {Ctx, Query, Resolver} from "type-graphql";
import {Order} from "../types/orderType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {Context} from "../types/not-graphql/contextType";
import prisma from "../../db/prisma";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";

@Resolver()
export class OrderResolver {

    // RESOLVER CUSTOM FOR ARCHIVE ITEMS

    @Query(returns => [Order])
    @RequireValidAccessToken()
    async getOrders_FULL(@Ctx() ctx: Context): Promise<Order[]> {
        const {user_id} = ctx
        const result = await prisma.orders.findMany({
            where: {
                user_id: user_id!,
                status: {
                    not: {
                        in: ["REQUIRES_PAYMENT", "CANCELLED"]
                    }
                }
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