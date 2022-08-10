export type RefundType = {
    items_refunded: {
        item_id: number,
        name: string,
        amount_refunded: number,
        price_per_unit: number,
        price_total: number,
        taxes: number
    }[],
    notes: string
    datetime: Date
}