import {Field, InputType} from "type-graphql";

@InputType()
export class ConfirmPaymentInput{
    @Field()
    payment_intent_id: string

    @Field(type => String, {nullable: true})
    cvc?: string
}