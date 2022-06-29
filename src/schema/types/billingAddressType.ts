import {Field, ObjectType} from "type-graphql";
import {Address} from "./addressType";

@ObjectType()
export class BillingAddress extends Address{
    @Field()
    country: string

    @Field(type => String, {nullable: true})
    notes: string | null
}