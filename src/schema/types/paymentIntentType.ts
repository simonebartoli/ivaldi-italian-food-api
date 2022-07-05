import {Field, ID, Int, ObjectType} from "type-graphql";

@ObjectType()
export class PaymentIntent{
    @Field(type => ID)
    id: string

    @Field()
    client_secret: string

    @Field()
    customer: string

    @Field(type => String)
    setup_future_usage: "on_session" | "off_session"

    @Field()
    status: string

    @Field(type => Int)
    amount: number

    @Field()
    currency: string

    @Field(type => String, {nullable: true})
    payment_method: string | null

    @Field(type => Int)
    created: number
}