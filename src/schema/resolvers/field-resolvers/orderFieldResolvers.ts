import {Ctx, FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {User} from "../../types/userType";
import {Order} from "../../types/orderType";
import {Context} from "../../types/not-graphql/contextType";
import {PaymentMethodDB} from "../../types/paymentMethodDBType";
import {OrderDelivery} from "../../types/orderDeliveryType";
import {Refund} from "../../types/refundType";

@Resolver(of => Order)
export class OrderFieldResolvers implements ResolverInterface<Order>{

    @FieldResolver()
    async user(@Root() order: Order, @Ctx() ctx: Context): Promise<User>{
        const {user_id, role} = ctx
        const result: [User] = await prisma.$queryRaw`
            SELECT u.* FROM users u
            INNER JOIN orders o on o.user_id = u.user_id
            WHERE o.order_id = ${order.order_id}
        `
        return role === "client" ?
            result.filter((_) => _.user_id === user_id)[0]! :
            result[0]
    }

    @FieldResolver()
    async payment_method(@Root() order: Order): Promise<PaymentMethodDB | null> {
        return await prisma.payment_methods.findUnique({
            where: {
                reference: order.reference
            }
        })
    }

    @FieldResolver()
    async order_delivery(@Root() order: Order): Promise<OrderDelivery> {
        return await prisma.orders_delivery.findUnique({
            where: {
                reference: order.reference
            }
        }) as OrderDelivery
    }

    @FieldResolver()
    async refund(@Root() order: Order): Promise<Refund[] | null> {
        let result = await prisma.refunds.findMany({
            where: {
                order_ref: order.reference
            }
        })
        if(result.length > 0){
            return result.map(element => {
                return {
                    ...element,
                    archive: JSON.parse(element.archive)
                }
            })
        }else {
            return null
        }
    }

}