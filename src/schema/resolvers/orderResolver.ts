import {Arg, Ctx, Mutation, Query, Resolver} from "type-graphql";
import {Order} from "../types/orderType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {Context} from "../types/not-graphql/contextType";
import prisma from "../../db/prisma";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";
import {OrderReceiptFilters} from "../inputs/orderReceiptFilters";
import {ConfirmDeliveryInput} from "../inputs/confirmDeliveryInput";
import {RequireAdmin} from "../custom-decorator/requireAdmin";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {CreateRefundInput} from "../inputs/createRefundInput";
import {DateTime} from "luxon";
import {CreateTimeslotDeliveryInput} from "../inputs/createTimeslotDeliveryInput";
import {refundPayment} from "./payments/paypal-api";

@Resolver()
export class OrderResolver {

    // RESOLVER CUSTOM FOR ARCHIVE ITEMS

    @Query(returns => [Order])
    @RequireValidAccessToken()
    async getOrders_FULL(@Ctx() ctx: Context, @Arg("filters", type => OrderReceiptFilters) filters: OrderReceiptFilters): Promise<Order[]> {
        const {user_id, role} = ctx

        const {priceMin, priceMax, dateMin, dateMax, order_ref} = filters
        const result = await prisma.orders.findMany({
            where: {
                reference: order_ref,
                user_id: role === "client" ? user_id! : undefined,
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

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async createTimeslotDelivery(@Arg("data", returns => CreateTimeslotDeliveryInput) inputData: CreateTimeslotDeliveryInput) {
        const {reference, timeslot} = inputData

        const result = await prisma.orders.findUnique({
            where: {
                reference: reference
            }
        })
        if(result === null) throw new DATA_ERROR("Order Not Found", DATA_ERROR_ENUM.ORDER_NOT_FOUND)
        if(result.status === "REQUIRES_PAYMENT" || result.status === "CANCELLED") throw new DATA_ERROR("Order Not Valid", DATA_ERROR_ENUM.ORDER_NOT_VALID)
        if(result.delivered) throw new DATA_ERROR("Order already delivered", DATA_ERROR_ENUM.ORDER_ALREADY_DELIVERED)

        await prisma.orders_delivery.update({
            where: {
                reference: reference
            },
            data: {
                confirmed: timeslot
            }
        })
        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async confirmDelivery(@Arg("data", returns => ConfirmDeliveryInput) inputData: ConfirmDeliveryInput) {
        const {reference, datetime} = inputData
        const result = await prisma.orders.findUnique({
            where: {
                reference: reference
            }
        })

        if(result === null) throw new DATA_ERROR("Order Not Found", DATA_ERROR_ENUM.ORDER_NOT_FOUND)
        if(result.status === "REQUIRES_PAYMENT" || result.status === "CANCELLED") throw new DATA_ERROR("Order Not Valid", DATA_ERROR_ENUM.ORDER_NOT_VALID)
        if(result.delivered) throw new DATA_ERROR("Order already delivered", DATA_ERROR_ENUM.ORDER_ALREADY_DELIVERED)


        if(result.status === "CONFIRMED"){
            await prisma.orders.update({
                where: {
                    reference: reference
                },
                data: {
                    delivered: true,
                    status: "DELIVERED"
                }
            })
        }else if(result.status === "REFUNDED") {
            await prisma.orders.update({
                where: {
                    reference: reference
                },
                data: {
                    delivered: true
                }
            })
        }
        await prisma.orders_delivery.update({
            where: {
                reference: reference
            },
            data: {
                actual: datetime
            }
        })
        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @RequireAdmin()
    async createRefund(@Ctx() ctx: Context, @Arg("data", returns => CreateRefundInput) inputData: CreateRefundInput){
        const {reference, archive, notes} = inputData
        const result = await prisma.orders.findUnique({
            include: {
                payment_methods: true
            },
            where: {
                reference: reference
            }
        })

        if(result === null) throw new DATA_ERROR("Order Not Found", DATA_ERROR_ENUM.ORDER_NOT_FOUND)
        if(result.status === "REQUIRES_PAYMENT" || result.status === "CANCELLED") throw new DATA_ERROR("Order Not Valid", DATA_ERROR_ENUM.ORDER_NOT_VALID)
        if(result.shipping_cost_refunded && inputData.shipping_cost) throw new DATA_ERROR("Order Not Valid", DATA_ERROR_ENUM.SHIPPING_COST_ALREADY_REFUNDED)

        const totalRefund = (() => {
            let total = 0
            archive.forEach(_ => {
                total += _.price_total
            })
            if(inputData.shipping_cost) {
                total += result.shipping_cost
            }
            return Number(total.toFixed(2))
        })()

        await prisma.$transaction(async prisma => {
            if(inputData.shipping_cost){
                await prisma.orders.update({
                    where: {
                        reference: inputData.reference
                    },
                    data: {
                        shipping_cost_refunded: true
                    }
                })
            }
            if(archive.length > 0){
                await prisma.refunds.create({
                    data: {
                        order_ref: reference,
                        archive: JSON.stringify(archive),
                        notes: notes,
                        datetime: DateTime.now().toJSDate()
                    }
                })
            }
            await prisma.orders.update({
                where: {
                    reference: reference
                },
                data: {
                    status: "REFUNDED"
                }
            })

            if(result.payment_methods!.type === "CARD") {
                await ctx.stripe.refunds.create({
                    payment_intent: result.order_id,
                    amount: Number((totalRefund * 100).toFixed(2))
                })
            }else if(result.payment_methods!.type === "PAYPAL") {
                await refundPayment(result.order_id, totalRefund.toFixed(2), notes)
            }
        })

        return true
    }
}