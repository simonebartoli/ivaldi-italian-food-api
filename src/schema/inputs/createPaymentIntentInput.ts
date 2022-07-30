import {Field, InputType} from "type-graphql";
import {IsPhoneNumber, MaxLength} from "class-validator";
import {BillingAddressInput, ShippingAddressInput} from "./addressInputs";

@InputType()
export class CreatePaymentIntentInput {
    @Field(type => BillingAddressInput)
    billing_address: BillingAddressInput

    @Field(type => ShippingAddressInput)
    shipping_address: ShippingAddressInput

    @Field()
    @IsPhoneNumber()
    phone_number: string

    @Field(type => String, {nullable: true})
    @MaxLength(99)
    delivery_suggested?: string

}