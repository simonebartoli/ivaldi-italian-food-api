import {Field, InputType, Int} from "type-graphql";
import {Length, Matches, MaxLength} from "class-validator";

@InputType()
export class EditAddressInput {
    @Field(type => Int)
    address_id: number

    @Field(type => String, {nullable: true})
    @Length(6, 99)
    first_address?: string

    @Field(type => String, {nullable: true})
    @Length(6, 99)
    @Matches(/\d/)
    second_address?: string

    @Field(type => String, {nullable: true})
    @Length(4, 8)
    postcode?: string

    @Field(type => String, {nullable: true})
    @Length(3, 30)
    city?: string

    @Field(type => String, {nullable: true})
    country?: string

    @Field(type => String, {nullable: true})
    @MaxLength(249)
    notes?: string

}