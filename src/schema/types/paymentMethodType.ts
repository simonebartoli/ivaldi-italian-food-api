import {Field, ObjectType} from "type-graphql";

@ObjectType()
export class PaymentMethod {
    @Field()
    payment_method_id: string

    @Field()
    last4: string

    @Field()
    exp_date: string

    @Field()
    brand: string
}