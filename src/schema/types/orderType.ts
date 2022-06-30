import {Field, Float, ID, ObjectType} from "type-graphql";
import {User} from "./userType";
import {OrderArchive} from "./archiveType";

@ObjectType()
export class Order {

    @Field(type => ID)
    order_id: number

    @Field(type => Float)
    price_total: number

    @Field(type => Float)
    shipping_cost: number

    @Field()
    datetime: Date

    @Field()
    archive: OrderArchive

    @Field(type => String)
    status: "DELIVERED" | "CANCELLED" | "PENDING"

    @Field(type => User)
    user?: User

}