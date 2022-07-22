import {Field, InputType, Int} from "type-graphql";

@InputType()
export class RemoveAddressInput {
    @Field(type => Int)
    address_id: number
}