import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {PaymentIntent} from "../../types/paymentIntentType";
import {RequireValidAccessToken} from "../../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../../custom-decorator/userInfo";
import {User} from "../../types/userType";
import {Context} from "../../types/not-graphql/contextType";
import {INTERNAL_ERROR} from "../../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../../enums/INTERNAL_ERROR_ENUM";
import {CartInfo} from "../../custom-decorator/cartInfo";
import {Cart} from "../../types/cartType";
import {CreatePaymentIntentInput} from "../../inputs/createPaymentIntentInput";
import {
    calculateTotal,
    cancelOrdersPaymentIntents,
    changeItemsAvailability,
    createArchive,
    verifyBillingAddress,
    verifyShippingAddress
} from "../../lib/paymentLib";
import hash from "object-hash";
import prisma from "../../../db/prisma";
import {CreatePendingOrderInput} from "../../inputs/createPendingOrderInput";
import {DATA_ERROR} from "../../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../../enums/DATA_ERROR_ENUM";
import {ORDER_STATUS_ENUM} from "../../enums/ORDER_STATUS_ENUM";
import {DateTime} from "luxon";
import {v4 as uuidv4} from "uuid";
import {AddPaymentMethodToPaymentIntentInput} from "../../inputs/addPaymentMethodToPaymentIntentInput";
import {ConfirmPaymentInput} from "../../inputs/confirmPaymentInput";
import {CreateCVCTokenInput} from "../../inputs/createCVCTokenInput";

@Resolver()
export class PaymentResolvers {

    // @Mutation(returns => PaymentIntent)
    // @RequireValidAccessToken()
    // async createNewPaymentIntent(@UserInfo() user: User, @Ctx() ctx: Context): Promise<PaymentIntent>{
    //     const testAmount = 100 // 1 GBP
    //     const result = await ctx.stripe.paymentIntents.create({
    //         amount: testAmount,
    //         currency: "gbp",
    //         payment_method_types: ["card"],
    //         customer: user.stripe_customer_id as string,
    //         setup_future_usage: "on_session"
    //     })
    //
    //     return {
    //         id: result.id,
    //         created: result.created,
    //         amount: result.amount,
    //         client_secret: result.client_secret as string,
    //         currency: result.currency,
    //         status: result.status,
    //         customer: result.customer as string,
    //     }
    // }

    @Mutation(returns => PaymentIntent)
    @RequireValidAccessToken()
    async createOrRetrievePaymentIntent (@UserInfo() user: User, @Ctx() ctx: Context, @CartInfo() cart: Cart[], @Arg("data") inputData: CreatePaymentIntentInput): Promise<PaymentIntent> {
        const {user_id} = ctx
        const {shipping_address, billing_address, phone_number, delivery_suggested} = inputData
        await verifyShippingAddress(shipping_address, user_id!)
        await verifyBillingAddress(billing_address, user_id!)
        const {total} = await calculateTotal(cart)
        const hashToCheck = hash([shipping_address, billing_address, {cart: Array.from(cart.entries())}, {user_id: user_id, total: total, phone_number: phone_number, delivery_suggested: delivery_suggested}])
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
                use_stripe_sdk: true,
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
                },
                confirmation_method: "manual"
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
    async addPaymentMethodToPaymentIntent(@Ctx() ctx: Context, @Arg("data") inputData: AddPaymentMethodToPaymentIntentInput) {
        const {payment_intent_id, payment_method_id, save_card, cvc} = inputData
        try{
            const result = await ctx.stripe.paymentIntents.retrieve(payment_intent_id)
            if(result.status === "canceled" || result.status === "succeeded" || result.status === "processing") throw new Error()
        }catch (e) {
            throw new DATA_ERROR("Payment Intent Not Valid", DATA_ERROR_ENUM.PAYMENT_ID_NOT_VALID)
        }

        try{
            await ctx.stripe.paymentIntents.update(payment_intent_id, {
                payment_method: payment_method_id,
                setup_future_usage: save_card ? "on_session" : undefined
            })
        }catch (e) {
            throw new DATA_ERROR("Payment Method Not Valid", DATA_ERROR_ENUM.PAYMENT_METHOD_NOT_VALID)
        }

        await this.confirmPayment(ctx,
            {
                payment_intent_id: payment_intent_id,
                cvc: cvc
            })
        return true
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async confirmPayment(@Ctx() ctx: Context, @Arg("data") inputData: ConfirmPaymentInput){
        const {payment_intent_id, cvc} = inputData

        await changeItemsAvailability(payment_intent_id, "SUBTRACT")

        let result
        try{
            result = await ctx.stripe.paymentIntents.confirm(payment_intent_id, {
               payment_method_options: {
                   card: {
                       cvc_token: cvc
                   }
               }
            })
        }catch (e) {
            await changeItemsAvailability(payment_intent_id, "REVERT")
            throw new DATA_ERROR((e as Error).message, DATA_ERROR_ENUM.PAYMENT_METHOD_NOT_VALID)
        }

        if(result){
            const status = result.status
            console.log(status)
            if(status === "requires_action"){
                await changeItemsAvailability(payment_intent_id, "REVERT")
                throw new DATA_ERROR("Requires Actions", DATA_ERROR_ENUM.PAYMENT_REQUIRES_ACTIONS)
            }
        }
        return true
    }

    @Mutation(returns => String)
    @RequireValidAccessToken()
    async createCVCToken(@Ctx() ctx: Context, @Arg("data") inputData: CreateCVCTokenInput){
        const {cvc} = inputData
        try{
            const resultObject = await ctx.stripe.tokens.create({
                cvc_update: {
                    cvc: cvc
                }
            })
            return  resultObject.id
        }catch (e) {
            throw new INTERNAL_ERROR("There is a problem with the payment provider.", INTERNAL_ERROR_ENUM.PAYMENT_PROVIDER_ERROR)
        }
    }

    /*
        DANGEROUS | CAN CREATE A BACKDOOR TO MALICIOUS USERS
     */

    // @Mutation(returns => Boolean)
    // @RequireValidAccessToken()
    // async setOrCheckItemsOnHold (@Arg("payment_intent_id") payment_intent_id: string, @Ctx() ctx: Context): Promise<true> {
    //     const order = await prisma.orders.findUnique({where: {order_id: payment_intent_id}})
    //     if (order === null) throw new DATA_ERROR("Order Not Found", DATA_ERROR_ENUM.ORDER_NOT_FOUND)
    //     const payment = await ctx.stripe.paymentIntents.retrieve(payment_intent_id)
    //     if(payment.status === "canceled" || payment.status === "succeeded") throw new DATA_ERROR("Payment ID Not Valid", DATA_ERROR_ENUM.PAYMENT_ID_NOT_VALID)
    //
    //     const datetime = DateTime.now().toISO()
    //
    //     const items = [...JSON.parse(order.archive).items] as OrderArchiveType["items"]
    //
    //     const cartFormattedMap = new Map<number, number>()
    //     const itemsAvailabilityMap = new Map<number, number>()
    //
    //     items.forEach((element) => {
    //         cartFormattedMap.set(element.item_id, element.amount)
    //         itemsAvailabilityMap.set(element.item_id, element.amount_available)
    //     })
    //
    //
    //     const result = await prisma.items_hold.findMany({
    //         where: {
    //             item_id: {
    //                 in: Array.from(cartFormattedMap.keys())
    //             },
    //             payment_intent_id: {
    //                 not: {
    //                     equals: payment_intent_id
    //                 }
    //             },
    //             expiry_datetime: {
    //                 gt: datetime
    //             }
    //         }
    //     })
    //     if(result.length > 0){
    //         for(const itemHold of result){
    //             if(itemHold.amount > (itemsAvailabilityMap.get(itemHold.item_id)! - cartFormattedMap.get(itemHold.item_id)!)){
    //                 throw new DATA_ERROR("Item in Use by Another Client", DATA_ERROR_ENUM.ITEM_ON_HOLD)
    //             }
    //         }
    //     }
    //
    //     const resultUser = await prisma.items_hold.findFirst({
    //         where: {
    //             payment_intent_id: payment_intent_id,
    //             expiry_datetime: {
    //                 gt: DateTime.now().toISO()
    //             }
    //         }
    //     })
    //     if(resultUser === null){
    //         await prisma.items_hold.deleteMany({where: {payment_intent_id: payment_intent_id}})
    //         const itemsHoldToInsert: {
    //             payment_intent_id: string
    //             item_id: number
    //             amount: number
    //             expiry_datetime: string
    //         }[] = []
    //         for(const [key, value] of cartFormattedMap.entries()) {
    //             itemsHoldToInsert.push({
    //                 payment_intent_id: payment_intent_id,
    //                 item_id: key,
    //                 amount: value,
    //                 expiry_datetime: DateTime.now().plus({minute: 5}).toISO()
    //             })
    //         }
    //         await prisma.items_hold.createMany({
    //             data: itemsHoldToInsert
    //         })
    //     }
    //     return true
    // }


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

}