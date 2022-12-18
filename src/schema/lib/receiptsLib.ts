import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";
import {OrderArchiveType} from "./paymentLib";
import {BillingAddress} from "../types/billingAddressType";
import {RefundType} from "./refundsLib";
import {DateTime} from "luxon";

export const retrieveOrderInfo = async (order_ref: string): Promise<InvoiceType> => {
    let result = await prisma.orders.findFirst({
        include: {
            users: {
                select: {
                    name: true,
                    surname: true,
                    email: true
                }
            },
            refunds: true,
            payment_methods: true
        },
        where: {
            reference: order_ref,
            status: {
                notIn: [ORDER_STATUS_ENUM.REQUIRES_PAYMENT, ORDER_STATUS_ENUM.CANCELLED]
            }
        }
    })
    if(result === null) throw new DATA_ERROR("Order Not Found", DATA_ERROR_ENUM.ORDER_NOT_FOUND)

    const archive = JSON.parse(result.archive) as OrderArchiveType

    const total = result.price_total
    const vatTotal = result.vat_total
    const shippingCost = result.shipping_cost

    const billingAddress = archive.billing_address
    const items = archive.items
    const invoiceNumber = result.receipt_number
    const datetime = result.datetime
    let refunds: RefundType[] = result.refunds.map(element => {
        return {
            items_refunded: JSON.parse(element.archive) as RefundType["items_refunded"],
            notes: element.notes,
            datetime: element.datetime
        }
    })
    refunds = refunds.sort((a, b) => DateTime.fromJSDate(a.datetime) > DateTime.fromJSDate(b.datetime) ? 1 : -1)

    return {
        billingAddress: billingAddress,
        items: items,
        refunds: refunds.length > 0 ? refunds : null,
        datetime: datetime,
        invoiceNumber: invoiceNumber,
        user: {
            name: result.users.name,
            surname: result.users.surname
        },
        payment_method: {
            type: result.payment_methods!.type as "CARD" | "PAYPAL",
            account: result.payment_methods!.account
        },
        shipping_cost: shippingCost,
        shipping_cost_refunded: result.shipping_cost_refunded,
        total: total,
        vat_total: vatTotal
    }
}


type InvoiceType = {
    billingAddress:  Omit<BillingAddress, "address_id">
    items: {
        item_id: number,
        name: string,
        amount: number,
        amount_available: number,
        price_per_unit: number,
        price_unit: string,
        price_total: number,
        photo_loc: string,
        vat: number
    }[]
    invoiceNumber: number
    datetime: Date
    refunds: RefundType[] | null,
    user: {
        name: string,
        surname: string
    }
    payment_method: {
        type: "CARD" | "PAYPAL",
        account: string
    }
    total: number
    vat_total: number
    shipping_cost: number
    shipping_cost_refunded: boolean
}