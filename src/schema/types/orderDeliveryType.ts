import {Field, Int, ObjectType} from "type-graphql";

@ObjectType()
export class OrderDelivery {
    @Field(type => Int)
    order_delivery_id: number

    @Field({nullable: true})
    suggested: string

    @Field({nullable: true})
    confirmed: string

    @Field(type => Date, {nullable: true})
    actual: Date

}