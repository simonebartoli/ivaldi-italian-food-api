import {Field, ID, InputType} from "type-graphql";

@InputType("AddressInput")
class AddressInput{
    @Field(type => ID)
    address_id: number

    @Field()
    city: string

    @Field()
    first_address: string

    @Field()
    postcode: string

    @Field(type => String, {nullable: true})
    second_address: string | null

    @Field(type => String, {nullable: true})
    coordinates: string | null

    @Field(type => String, {nullable: true})
    notes: string | null
}


@InputType("ShippingAddressInput")
export class ShippingAddressInput extends AddressInput{
    // @Field(type => COUNTRY_ALLOWED_ENUM, {nullable: true, defaultValue: COUNTRY_ALLOWED_ENUM.UNITED_KINGDOM})
    // country: string
}

@InputType("BillingAddressInput")
export class BillingAddressInput extends AddressInput{
    @Field(type => String)
    country: string
}