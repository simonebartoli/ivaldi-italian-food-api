import {Ctx, Query, Resolver} from "type-graphql";
import {Order} from "../types/orderType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {Context} from "../types/not-graphql/contextType";
import prisma from "../../db/prisma";

@Resolver()
export class OrderResolver {

    @Query(returns => [Order])
    @RequireValidAccessToken()
    async getOrders_FULL(@Ctx() ctx: Context): Promise<Order[]> {
        const {user_id} = ctx
        const result: any[] = await prisma.$queryRaw`
            SELECT * FROM orders WHERE user_id = ${user_id}
        `
        return result.map((element) => {
            return {
                ...element,
                archive: JSON.parse(element.archive)
            }
        })

    }

}