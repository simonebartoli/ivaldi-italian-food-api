import {Ctx, FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {User} from "../../types/userType";
import {Order} from "../../types/orderType";
import {Context} from "../../types/not-graphql/contextType";
import {PaymentMethodDB} from "../../types/paymentMethodDBType";

@Resolver(of => Order)
export class OrderFieldResolvers implements ResolverInterface<Order>{

    @FieldResolver()
    async user(@Root() order: Order, @Ctx() ctx: Context): Promise<User>{
        const {user_id} = ctx
        const result: [User] = await prisma.$queryRaw`
            SELECT u.* FROM orders
            INNER JOIN users u on orders.user_id = u.user_id
            WHERE orders.user_id = ${user_id}
        `
        return result[0]
    }

    @FieldResolver()
    async payment_method(@Root() order: Order): Promise<PaymentMethodDB | null> {
        return await prisma.payment_methods.findUnique({
            where: {
                reference: order.reference
            }
        })
    }

}