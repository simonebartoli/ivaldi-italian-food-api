import {Field, Float, ID, ObjectType} from "type-graphql";
import {User} from "./userType";
import {Archive} from "./archiveType";
import {ORDER_STATUS_ENUM} from "../enums/ORDER_STATUS_ENUM";

@ObjectType()
export class Order {

    @Field(type => ID)
    order_id: string

    @Field(type => Float)
    price_total: number

    @Field(type => Float)
    shipping_cost: number

    @Field(type => Float)
    vat_total: number

    @Field()
    datetime: Date

    @Field()
    archive: Archive

    @Field(type => ORDER_STATUS_ENUM)
    status: ORDER_STATUS_ENUM

    @Field()
    reference: string

    @Field(type => User)
    user?: User

}