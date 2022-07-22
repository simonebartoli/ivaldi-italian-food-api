import {Field, InputType, Int} from "type-graphql";
import {IsInt, Min} from "class-validator";

@InputType()
export class ItemCart {
    @Field(type => Int)
    @IsInt()
    @Min(0)
    item_id: number

    @Field(type => Int)
    @IsInt()
    amount: number
}