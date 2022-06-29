import {Field, ObjectType} from "type-graphql";
import {Address} from "./addressType";

@ObjectType()
export class ShippingAddress extends Address{
    @Field(type => String, {nullable: true})
    notes: string | null
}