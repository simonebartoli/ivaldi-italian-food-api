import {Field, InputType, Int} from "type-graphql";

@InputType()
export class AddEntryToCartInput {
    @Field(type => Int)
    item_id: number

    @Field(type => Int)
    amount: number
}