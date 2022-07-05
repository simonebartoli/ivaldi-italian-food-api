import {Field, InputType} from "type-graphql";

@InputType()
export class ConfirmCardPaymentIntentInput{
    @Field()
    payment_intent_id: string

    @Field()
    card_fingerprint: string
}