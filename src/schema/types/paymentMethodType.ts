import {Field, ID, Int, ObjectType} from "type-graphql";

@ObjectType()
export class PaymentMethod{
    @Field(type => ID)
    id: string

    @Field()
    fingerprint: string

    @Field()
    brand: string

    @Field(type => Int)
    exp_month: number

    @Field(type => Int)
    exp_year: number

    @Field()
    last4: string

    @Field(type => String)
    customer: string

    @Field(type => Int)
    created: number
}