import {Field, Float, ID, Int, ObjectType} from "type-graphql";
import {User} from "./userType";
import {Archive} from "./archiveType";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";
import {PaymentMethodDB} from "./paymentMethodDBType";
import {OrderDelivery} from "./orderDeliveryType";
import {Refund} from "./refundType";

@ObjectType()
export class Order {

    @Field(type => ID)
    order_id: string

    @Field(type => Float)
    price_total: number

    @Field(type => Float)
    shipping_cost: number

    @Field(type => Boolean)
    shipping_cost_refunded: boolean

    @Field(type => Float)
    vat_total: number

    @Field(() => String)
    phone_number: string

    @Field()
    datetime: Date

    @Field()
    archive: Archive

    @Field(type => ORDER_STATUS_ENUM)
    status: ORDER_STATUS_ENUM

    @Field()
    reference: string

    @Field(type => Int)
    receipt_number: number

    @Field(type => PaymentMethodDB, {nullable: true})
    payment_method?: PaymentMethodDB | null

    @Field(type => User)
    user?: User

    @Field(type => OrderDelivery)
    order_delivery?: OrderDelivery

    @Field(type => [Refund], {nullable: true})
    refund?: Refund[] | null
}