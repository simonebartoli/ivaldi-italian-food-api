import {Context} from "../types/not-graphql/contextType";
import {ShippingAddress} from "../types/shippingAddressType";
import {BillingAddress} from "../types/billingAddressType";
import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {Cart} from "../types/cartType";
import {Item} from "../types/itemType";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";
import hash from "object-hash";
import {CreatePaymentIntentInput} from "../inputs/createPaymentIntentInput";
import {CreatePendingOrderInput} from "../inputs/createPendingOrderInput";
import {DateTime} from "luxon";
import {v4 as uuidv4} from "uuid";
import {createEmail_OrderConfirmation} from "./emailsLib";
import {DOMAIN, MIN_ORDER_PRICE, REVALIDATE_TOKEN} from "../../bin/settings";
import {BAD_REQ_ERROR} from "../../errors/BAD_REQ_ERROR";
import {BAD_REQ_ERROR_ENUM} from "../enums/BAD_REQ_ERROR_ENUM";
import axios from "axios";

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


export const checkForHolidays = async () => {
    const currentDate = DateTime.now()
    const result = await prisma.holidays.findFirst({
        where: {
            start_date: {
                lte: currentDate.toJSDate()
            },
            end_date: {
                gte: currentDate.toJSDate()
            }
        }
    })
    if(result !== null) throw new BAD_REQ_ERROR("No purchase during holidays", BAD_REQ_ERROR_ENUM.HOLIDAY_PERIOD)
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
            vatTotal += item.price_total * cartFormatted.get(item.item_id)! * (item.vat.percentage / 100)
        }else
            throw new DATA_ERROR("There are some changes in the cart, Check and Try Again", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
    }

    if(total < MIN_ORDER_PRICE) throw new DATA_ERROR(`Your order needs to be at least £${total.toFixed(2)}`, DATA_ERROR_ENUM.MIN_ORDER_NOT_RESPECTED)

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

export const cancelOrdersPaymentIntents = async (ctx: Context, payment_intent_id: string, type: "STRIPE" | "PAYPAL") => {
    const {user_id, stripe} = ctx
    const result = await prisma.orders.findMany({
        where: {
            order_id: {
                not: {
                    equals: payment_intent_id
                }
            },
            type: type,
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

        if(type === "STRIPE"){
            for(const element of result) await stripe.paymentIntents.cancel(element.order_id)
        }
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
export const checkAndHashInformation = async (ctx: Context, inputData: CreatePaymentIntentInput, cart: Cart[], total: number, type: "CARD" | "PAYPAL"): Promise<string> => {
    const {user_id} = ctx
    const {shipping_address, billing_address, phone_number, delivery_suggested} = inputData
    await verifyShippingAddress(shipping_address, user_id!)
    await verifyBillingAddress(billing_address, user_id!)
    return hash([shipping_address, billing_address, {cart: Array.from(cart.entries())}, {
        user_id: user_id,
        total: total,
        phone_number: phone_number,
        delivery_suggested: delivery_suggested,
        type: type
    }])
}
export const createPendingOrder = async (ctx: Context, cart: Cart[], inputData: CreatePendingOrderInput, type: "PAYPAL" | "STRIPE"): Promise<{reference: string, receipt_number: number}> => {
    const {user_id} = ctx
    const {payment_intent_id, shipping_address, billing_address, phone_number, delivery_suggested} = inputData
    const datetime = DateTime.now().toISO()
    const reference = uuidv4()

    await cancelOrdersPaymentIntents(ctx, payment_intent_id, type)

    const orderFound = await prisma.orders.findUnique({where: {order_id: payment_intent_id}})
    if(orderFound !== null) return {
        reference: orderFound.reference,
        receipt_number: orderFound.receipt_number
    }

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
    const result = await prisma.orders.create({
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
            reference: reference,
            type: type
        }
    })
    await prisma.orders_delivery.create({
        data: {
            reference: result.reference,
            suggested: delivery_suggested === "" ? null : delivery_suggested
        }
    })
    return {
        reference: result.reference,
        receipt_number: result.receipt_number
    }
}

export const postPaymentOperations = async (payment_intent_id: string, user_id: number, type: "CARD" | "PAYPAL", account: string) => {
    const order = await prisma.orders.update({
        data: {
            status: ORDER_STATUS_ENUM.CONFIRMED
        },
        where: {
            order_id: payment_intent_id
        },
        include: {
            users: true
        }
    })
    await prisma.carts.deleteMany({where: {user_id: user_id}})
    await prisma.payment_intents.delete({
        where: {
            payment_intent_id: payment_intent_id
        }
    })
    await prisma.payment_methods.create({
        data: {
            reference: order!.reference,
            type: type,
            account: account
        }
    })

    const archive = JSON.parse(order.archive) as OrderArchiveType
    for(const element of archive.items){
        try{
            const response = await axios.get(`${DOMAIN}/api/revalidate?secret=${REVALIDATE_TOKEN}&id=${element.item_id}`)
            console.log(response.data)
        }catch (e) {
            console.log((e as Error).message)
        }
    }

    try{
        await createEmail_OrderConfirmation({
            to: order.users.email!,
            name: order.users.name,
            datetime: DateTime.fromJSDate(order.datetime).toLocaleString(DateTime.DATETIME_SHORT),
            surname: order.users.surname,
            reference: order.reference
        })
    }catch (e) {

    }
}