import {Arg, Ctx, Mutation, Query, Resolver} from "type-graphql";
import {PaymentIntent} from "../types/paymentIntentType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../custom-decorator/userInfo";
import {User} from "../types/userType";
import {Context} from "../types/not-graphql/contextType";
import {PaymentMethod} from "../types/paymentMethodType";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";
import {CartInfo} from "../custom-decorator/cartInfo";
import {Cart} from "../types/cartType";
import {CreatePaymentIntentInput} from "../inputs/createPaymentIntentInput";
import {
    calculateTotal, cancelOrdersPaymentIntents,
    createArchive,
    OrderArchiveType,
    verifyBillingAddress,
    verifyShippingAddress
} from "../lib/paymentLib";
import hash from "object-hash";
import prisma from "../../db/prisma";
import {CreatePendingOrderInput} from "../inputs/createPendingOrderInput";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";
import {DateTime} from "luxon";
import {v4 as uuidv4} from "uuid";

@Resolver()
export class PaymentResolvers {

    @Mutation(returns => PaymentIntent)
    @RequireValidAccessToken()
    async createNewPaymentIntent(@UserInfo() user: User, @Ctx() ctx: Context): Promise<PaymentIntent>{
        const testAmount = 100 // 1 GBP
        const result = await ctx.stripe.paymentIntents.create({
            amount: testAmount,
            currency: "gbp",
            payment_method_types: ["card"],
            customer: user.stripe_customer_id as string,
            setup_future_usage: "on_session"
        })

        return {
            id: result.id,
            created: result.created,
            amount: result.amount,
            client_secret: result.client_secret as string,
            currency: result.currency,
            status: result.status,
            customer: result.customer as string,
        }
    }

    @Mutation(returns => PaymentIntent)
    @RequireValidAccessToken()
    async createOrRetrievePaymentIntent (@UserInfo() user: User, @Ctx() ctx: Context, @CartInfo() cart: Cart[], @Arg("data") inputData: CreatePaymentIntentInput): Promise<PaymentIntent> {
        const {user_id} = ctx
        const {shipping_address, billing_address, phone_number, delivery_suggested} = inputData
        await verifyShippingAddress(shipping_address, user_id!)
        await verifyBillingAddress(billing_address, user_id!)
        const {total} = await calculateTotal(cart)
        const hashToCheck = hash([shipping_address, billing_address, {cart: Array.from(cart.entries())}, {user_id: user_id}, {total: total}, {phone_number: phone_number}])
        const resultHash = await prisma.payment_intents.findFirst({
            where: {
                hash: hashToCheck
            }
        })

        let previousIdNotValid = false
        if(resultHash !== null) {
            if(DateTime.fromJSDate(resultHash.expiry_datetime) < DateTime.now()) {
                await prisma.payment_intents.delete({where: {payment_intent_id: resultHash.payment_intent_id}})
                previousIdNotValid = true
            }
        }

        if(resultHash === null || previousIdNotValid){
            const paymentIntent = await ctx.stripe.paymentIntents.create({
                amount: Number((total*100).toFixed(0)),
                currency: "gbp",
                customer: user.stripe_customer_id ? user.stripe_customer_id : undefined,
                payment_method_types: ["card"],
                setup_future_usage: undefined,
                shipping: {
                    name: `${user.name} ${user.surname}`,
                    address: {
                        line1: shipping_address.first_address,
                        line2: shipping_address.second_address ? shipping_address.second_address : undefined,
                        city: shipping_address.city,
                        country: "United Kingdom",
                        postal_code: shipping_address.postcode
                    },
                    phone: phone_number
                }
            })
            await prisma.payment_intents.create({
                data: {
                    payment_intent_id: paymentIntent.id,
                    hash: hashToCheck,
                    expiry_datetime: DateTime.now().plus({hour: 1}).toISO()
                }
            })
            await this.createPendingOrder(ctx, cart, {
                payment_intent_id: paymentIntent.id,
                phone_number: phone_number,
                billing_address: billing_address,
                shipping_address: shipping_address,
                delivery_suggested: delivery_suggested
            })
            return {
                id: paymentIntent.id,
                created: paymentIntent.created,
                amount: paymentIntent.amount,
                status: paymentIntent.status,
                currency: paymentIntent.currency,
                client_secret: paymentIntent.client_secret as string,
                customer: paymentIntent.customer ? paymentIntent.customer as string : null
            }
        }else{
            const paymentIntent = await ctx.stripe.paymentIntents.retrieve(resultHash.payment_intent_id)
            await this.createPendingOrder(ctx, cart, {
                payment_intent_id: paymentIntent.id,
                phone_number: phone_number,
                billing_address: billing_address,
                shipping_address: shipping_address,
                delivery_suggested: delivery_suggested
            })
            return {
                id: paymentIntent.id,
                created: paymentIntent.created,
                amount: paymentIntent.amount,
                status: paymentIntent.status,
                currency: paymentIntent.currency,
                client_secret: paymentIntent.client_secret as string,
                customer: paymentIntent.customer ? paymentIntent.customer as string : null
            }
        }
    }

    async createPendingOrder (ctx: Context, cart: Cart[], inputData: CreatePendingOrderInput): Promise<boolean> {
        const {user_id} = ctx
        const {payment_intent_id, shipping_address, billing_address, phone_number, delivery_suggested} = inputData
        const datetime = DateTime.now().toISO()
        const reference = uuidv4()

        await cancelOrdersPaymentIntents(ctx, payment_intent_id)
        if(await prisma.orders.findUnique({where: {order_id: payment_intent_id}}) !== null) return true

        const items = await prisma.items.findMany({
            include: {
                vat: true
            },
            where: {
                item_id: {
                    in: cart.map((element) => element.item_id)
                }
            }
        })
        if(items === null) throw new DATA_ERROR("Your Cart Cannot Be Empty", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)

        const {total, vatTotal} = await calculateTotal(cart)
        const archive = createArchive({
            shipping_address: shipping_address,
            billing_address: billing_address,
            cart: cart,
            items: items
        })
        // console.log(archive)
        const shipping_cost = 0
        const status = ORDER_STATUS_ENUM.REQUIRES_PAYMENT
        await prisma.orders.create({
            data: {
                order_id: payment_intent_id,
                price_total: total,
                vat_total: vatTotal,
                datetime: datetime,
                shipping_cost: shipping_cost,
                phone_number: phone_number,
                status: status,
                user_id: user_id!,
                archive: JSON.stringify(archive),
                reference: reference
            }
        })
        await prisma.orders_delivery.create({
            data: {
                order_id: payment_intent_id,
                suggested: delivery_suggested
            }
        })
        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async setOrCheckItemsOnHold (@Arg("payment_intent_id") payment_intent_id: string): Promise<true> {
        const order = await prisma.orders.findUnique({where: {order_id: payment_intent_id}})
        if (order === null) throw new DATA_ERROR("Order Not Found", DATA_ERROR_ENUM.ORDER_NOT_FOUND)
        const datetime = DateTime.now().toISO()

        const items = [...JSON.parse(order.archive).items] as OrderArchiveType["items"]

        const cartFormattedMap = new Map<number, number>()
        const itemsAvailabilityMap = new Map<number, number>()

        items.forEach((element) => {
            cartFormattedMap.set(element.item_id, element.amount)
            itemsAvailabilityMap.set(element.item_id, element.amount_available)
        })


        const result = await prisma.items_hold.findMany({
            where: {
                item_id: {
                    in: Array.from(cartFormattedMap.keys())
                },
                payment_intent_id: {
                    not: {
                        equals: payment_intent_id
                    }
                },
                expiry_datetime: {
                    gt: datetime
                }
            }
        })
        if(result.length > 0){
            for(const itemHold of result){
                if(itemHold.amount > (itemsAvailabilityMap.get(itemHold.item_id)! - cartFormattedMap.get(itemHold.item_id)!)){
                    throw new DATA_ERROR("Item in Use by Another Client", DATA_ERROR_ENUM.ITEM_ON_HOLD)
                }
            }
        }

        const resultUser = await prisma.items_hold.findFirst({
            where: {
                payment_intent_id: payment_intent_id,
                expiry_datetime: {
                    gt: DateTime.now().toISO()
                }
            }
        })
        if(resultUser === null){
            await prisma.items_hold.deleteMany({where: {payment_intent_id: payment_intent_id}})
            const itemsHoldToInsert: {
                payment_intent_id: string
                item_id: number
                amount: number
                expiry_datetime: string
            }[] = []
            for(const [key, value] of cartFormattedMap.entries()) {
                itemsHoldToInsert.push({
                    payment_intent_id: payment_intent_id,
                    item_id: key,
                    amount: value,
                    expiry_datetime: DateTime.now().plus({minute: 5}).toISO()
                })
            }
            await prisma.items_hold.createMany({
                data: itemsHoldToInsert
            })
        }
        return true
    }


    /*
        NOT USEFUL | STRIPE DO IT WITH CONFIRM CARD PAYMENT
        https://stripe.com/docs/js/payment_intents/confirm_card_payment
     */

    // @Mutation(returns => Boolean)
    // @RequireValidAccessToken()
    // async confirmPaymentIntent(@Arg("data") inputData: ConfirmCardPaymentIntentInput, @UserInfo() user: User, @Ctx() ctx: Context): Promise<boolean> {
    //     const payment_method_id: string | undefined = await getPaymentMethodIDFromFingerprint(inputData.card_fingerprint, user, ctx)
    //     if(payment_method_id === undefined){
    //         throw new PAYMENT_ERROR("Method Provided for Payment is Not Valid", PAYMENT_ERROR_ENUM.FINGERPRINT_NOT_VALID)
    //     }
    //     await verifyPaymentIntentFromID(inputData.payment_intent_id, user, ctx)
    //
    //     await ctx.stripe.paymentIntents.confirm(
    //         inputData.payment_intent_id,
    //         {payment_method: payment_method_id}
    //     )
    //
    //     return true
    // }

    @Query(returns => [PaymentMethod])
    @RequireValidAccessToken()
    async getPaymentMethod(@UserInfo() user: User, @Ctx() ctx: Context): Promise<PaymentMethod[]> {
        if (user.stripe_customer_id !== null) {
            const result = await ctx.stripe.customers.listPaymentMethods(
                user.stripe_customer_id,
                {type: "card"}
            )
            const resultFormatted: PaymentMethod[] = []
            for(const element of result.data){
                if(element.card?.wallet === null && element.card !== undefined){
                    resultFormatted.push(<PaymentMethod>{
                        id: element.id,
                        fingerprint: element.card.fingerprint,
                        created: element.created,
                        customer: element.customer,
                        brand: element.card.brand,
                        exp_month: element.card.exp_month,
                        exp_year: element.card.exp_year,
                        last4: element.card.last4
                    })
                }
            }
            return resultFormatted
        }
        throw new INTERNAL_ERROR("Generic Error in Payment", INTERNAL_ERROR_ENUM.PAYMENT_ERROR)
    }
}