import {Field, InputType, Int} from "type-graphql";
import {Max, Min} from "class-validator";

@InputType()
export class AddEntryToCartInput {
    @Field(type => Int)
    item_id: number

    @Field(type => Int)
    @Min(1)
    @Max(10)
    amount: number
}