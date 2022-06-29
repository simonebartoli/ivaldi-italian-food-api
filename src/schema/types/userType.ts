import {Field, ID, ObjectType} from "type-graphql";
import {BillingAddress} from "./billingAddressType";
import {ShippingAddress} from "./shippingAddressType";
import {Cart} from "./cartType";

@ObjectType()
export class User {
    @Field(type => ID)
    user_id: number

    @Field()
    name: string

    @Field()
    surname: string

    @Field()
    email: string

    @Field()
    dob: Date

    @Field()
    role: string

    @Field(type => [BillingAddress], {nullable: true})
    billing_addresses?: BillingAddress[]

    @Field(type => [ShippingAddress], {nullable: true})
    shipping_addresses?: ShippingAddress[]

    @Field(type => [Cart], {nullable: true})
    cart?: Cart[]
}