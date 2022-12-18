import {Field, Float, Int, ObjectType} from "type-graphql";

@ObjectType()
export class ShippingCost {
    @Field(type => Int)
    max_weight: number

    @Field(type => Float)
    price: number
}