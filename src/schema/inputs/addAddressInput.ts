import {Field, InputType} from "type-graphql";
import {Length, Matches, MaxLength} from "class-validator";
import {ADDRESS_TYPE_ENUM} from "../enums/ADDRESS_TYPE_ENUM";

@InputType()
export class AddAddressInput {
    @Field()
    @Length(6, 99)
    first_address: string

    @Field(type => String, {nullable: true})
    @Length(6, 99)
    @Matches(/\d/)
    second_address?: string

    @Field()
    @Length(4, 8)
    postcode: string

    @Field()
    @Length(3, 30)
    city: string

    @Field()
    country: string

    @Field(type => String, {nullable: true})
    @MaxLength(249)
    notes?: string

    @Field(type => ADDRESS_TYPE_ENUM)
    type: ADDRESS_TYPE_ENUM
}