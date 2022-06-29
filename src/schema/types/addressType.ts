import {Field, ID, ObjectType} from "type-graphql";

@ObjectType()
export class Address {
    @Field(type => ID)
    address_id: number

    @Field()
    city: string

    @Field()
    first_address: string

    @Field(type => String, {nullable: true})
    second_address: string | null

}