import {Field, ID, Int, ObjectType} from "type-graphql";

@ObjectType()
export class PaymentIntent{
    @Field(type => ID)
    id: string

    @Field()
    client_secret: string

    @Field(type => String, {nullable: true})
    customer: string | null

    @Field()
    status: string

    @Field(type => Int)
    amount: number

    @Field()
    currency: string

    @Field(type => Int)
    created: number
}