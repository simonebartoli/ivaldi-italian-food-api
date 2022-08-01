import {User} from "../types/userType";
import {Context} from "../types/not-graphql/contextType";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";
import {PAYMENT_ERROR} from "../../errors/PAYMENT_ERROR";
import {PAYMENT_ERROR_ENUM} from "../enums/PAYMENT_ERROR_ENUM";
import {ShippingAddress} from "../types/shippingAddressType";
import {BillingAddress} from "../types/billingAddressType";
import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {Cart} from "../types/cartType";
import {Item} from "../types/itemType";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";

export type OrderArchiveType = {
    shipping_address: Omit<ShippingAddress, "address_id">
    billing_address: Omit<BillingAddress, "address_id">
    items: {
        item_id: number
        name: string
        amount: number
        amount_available: number
        price_per_unit: number
        price_unit: string
        price_total: number
        photo_loc: string
        vat: number
    }[]
}
type CreateOrderArchiveType = {
    shipping_address: ShippingAddress
    billing_address: BillingAddress
    items: (Item & {vat: {percentage: number}})[]
    cart: {
        item_id: number
        amount: number
    }[]
}


export const getPaymentMethodIDFromFingerprint = async (fingerprint: string, user: User, ctx: Context): Promise<string | undefined> => {
    if (user.stripe_customer_id !== null) {
        const result = await ctx.stripe.customers.listPaymentMethods(
            user.stripe_customer_id,
            {type: "card"}
        )
        return result.data.find((element) =>
            element.card !== undefined && element.card.fingerprint === fingerprint
        )?.id
    }
    throw new INTERNAL_ERROR("Generic Error in Payment", INTERNAL_ERROR_ENUM.PAYMENT_ERROR)
}
export const verifyPaymentIntentFromID = async (payment_intent_id: string, user: User, ctx: Context) => {
    let result
    try{
        result = await ctx.stripe.paymentIntents.retrieve(payment_intent_id)
    }catch (e){
        throw new PAYMENT_ERROR("Payment Intent ID Not Valid", PAYMENT_ERROR_ENUM.PAYMENT_INTENT_NOT_VALID)
    }

    if(result.status === "succeeded" || result.status === "canceled"){
        throw new PAYMENT_ERROR("Payment Intent ID Not Valid", PAYMENT_ERROR_ENUM.PAYMENT_INTENT_NOT_VALID)
    }
    if(result.customer === null || result.customer !== user.stripe_customer_id){
        throw new PAYMENT_ERROR("Payment Intent ID Not Valid", PAYMENT_ERROR_ENUM.PAYMENT_INTENT_NOT_VALID)
    }
}

export const verifyShippingAddress = async (address: ShippingAddress, user_id: number) => {
    try{
        await prisma.addresses.findFirstOrThrow({
                where: {
                    address_id: Number(address.address_id),
                    first_address: address.first_address,
                    second_address: address.second_address,
                    postcode: address.postcode,
                    city: address.city,
                    user_id: user_id
                }
            })
    }catch (e) {
        throw new DATA_ERROR("The Shipping Address Provided Does Not Exist", DATA_ERROR_ENUM.ADDRESS_NOT_EXISTING)
    }
}
export const verifyBillingAddress = async (address: BillingAddress, user_id: number) => {
    try{
        await prisma.addresses.findFirstOrThrow({
                where: {
                    address_id: Number(address.address_id),
                    first_address: address.first_address,
                    second_address: address.second_address,
                    postcode: address.postcode,
                    city: address.city,
                    user_id: user_id,
                    billing_addresses: {
                        country: address.country
                    }
                }
            })
    }catch (e) {
        throw new DATA_ERROR("The Billing Address Provided Does Not Exist", DATA_ERROR_ENUM.ADDRESS_NOT_EXISTING)
    }
}
export const calculateTotal = async (cart: Cart[]): Promise<{ total: number, vatTotal: number }> => {
    const cartFormatted = new Map<number, number>()
    for(const item of cart) cartFormatted.set(item.item_id, item.amount)

    const items = await prisma.items.findMany({
        include: {
            vat: true
        },
        where: {
            item_id: {
                in: Array.from(cartFormatted.keys())
            }
        }
    })

    let total = 0
    let vatTotal = 0

    for(const item of items) {
        if(cartFormatted.has(item.item_id)) {
            total += item.price_total * cartFormatted.get(item.item_id)!
            vatTotal += item.price_total * cartFormatted.get(item.item_id)! * (item.vat.percentage !== 0 ? item.vat.percentage / 100 : 1)
        }else
            throw new DATA_ERROR("There are some changes in the cart, Check and Try Again", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
    }

    return {
        total: Number(total.toFixed(2)),
        vatTotal: Number(vatTotal.toFixed(2))
    }
}
export const createArchive = (data: CreateOrderArchiveType) => {
    const {billing_address, shipping_address, items, cart} = data
    let {address_id: _, ...billing_address_formatted} = billing_address
    let {address_id: __, ...shipping_address_formatted} = shipping_address
    const cartFormatted = new Map<number, number>()
    for(const item of cart) cartFormatted.set(item.item_id, item.amount)

    const archive: OrderArchiveType = {
        shipping_address: shipping_address_formatted,
        billing_address: billing_address_formatted,
        items: items.map((element => {
            return {
                item_id: element.item_id,
                name: element.name,
                amount: cartFormatted.get(element.item_id)!,
                amount_available: element.amount_available,
                price_per_unit: element.price_total,
                price_unit: element.price_unit,
                price_total: Number((element.price_total * cartFormatted.get(element.item_id)!).toFixed(2)),
                photo_loc: element.photo_loc,
                vat: element.vat.percentage
            }
        }))
    }
    return archive
}

export const cancelOrdersPaymentIntents = async (ctx: Context, payment_intent_id: string) => {
    const {user_id, stripe} = ctx
    const result = await prisma.orders.findMany({
        where: {
            order_id: {
                not: {
                    equals: payment_intent_id
                }
            },
            user_id: user_id!,
            status: ORDER_STATUS_ENUM.REQUIRES_PAYMENT
        }
    })
    if(result.length > 0){
        await prisma.orders.updateMany({
            data: {
                status: ORDER_STATUS_ENUM.CANCELLED
            },
            where: {
                order_id: {
                    in: result.map(element => element.order_id)
                }
            }
        })
        await prisma.payment_intents.deleteMany({
            where: {
                payment_intent_id: {
                    in: result.map(element => element.order_id)
                }
            }
        })
        await prisma.items_hold.deleteMany({
            where: {
                payment_intent_id: {
                    in: result.map(element => element.order_id)
                }
            }
        })

        for(const element of result) await stripe.paymentIntents.cancel(element.order_id)
    }
}
export const changeItemsAvailability = async (order_id: string, actionType: "SUBTRACT" | "REVERT") => {
    const archive = JSON.parse((await prisma.orders.findUniqueOrThrow({
        where: {
            order_id: order_id
        }
    })).archive) as OrderArchiveType
    const items = archive.items.map((element) => {
        return {
            item_id: element.item_id,
            amount: element.amount
        }
    })
    if(actionType === "SUBTRACT"){
        try{
            await prisma.$transaction(async (prisma) => {
                for(const item of items){
                    await prisma.items.update({
                        data: {
                            amount_available: {
                                decrement: item.amount
                            }
                        },
                        where: {
                            item_id: item.item_id
                        }
                    })
                }
            })
        }catch (e) {
            throw new DATA_ERROR("Items Not Available", DATA_ERROR_ENUM.AMOUNT_NOT_AVAILABLE)
        }
    }else {
        await prisma.$transaction(async (prisma) => {
            for(const item of items){
                await prisma.items.update({
                    data: {
                        amount_available: {
                            increment: item.amount
                        }
                    },
                    where: {
                        item_id: item.item_id
                    }
                })
            }
        })
    }
}