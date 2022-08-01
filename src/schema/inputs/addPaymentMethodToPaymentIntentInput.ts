import {Field, InputType} from "type-graphql";

@InputType()
export class AddPaymentMethodToPaymentIntentInput{
    @Field()
    payment_intent_id: string

    @Field()
    payment_method_id: string

    @Field(type => Boolean)
    save_card: boolean
}