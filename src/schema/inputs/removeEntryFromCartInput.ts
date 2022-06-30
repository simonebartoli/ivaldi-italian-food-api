import {Field, InputType, Int} from "type-graphql";
import {Min} from "class-validator";

@InputType()
export class RemoveEntryFromCartInput {
    @Field(type => Int)
    item_id: number

    @Field(type => Int, {nullable: true})
    @Min(1)
    amount?: number
}