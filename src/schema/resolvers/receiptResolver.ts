import {Ctx, Query, Resolver} from "type-graphql";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {Context} from "../types/not-graphql/contextType";
import prisma from "../../db/prisma";
import {Receipt} from "../types/receiptType";

@Resolver()
export class ReceiptResolver {

    @Query(returns => [Receipt])
    @RequireValidAccessToken()
    async getReceipts_FULL(@Ctx() ctx: Context): Promise<Receipt[]> {
        const {user_id} = ctx
        const result = await prisma.receipts.findMany({
            where: {
                orders: {
                    user_id: user_id!
                }
            }
        })
        return result.map((element) => {
            return {
                ...element,
                status: element.status as "COMPLETED" | "REFUNDED",
                archive: JSON.parse(element.archive)
            }
        })

    }

}