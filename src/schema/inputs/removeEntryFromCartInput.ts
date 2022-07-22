import {Field, InputType, Int} from "type-graphql";

@InputType()
export class RemoveEntryFromCartInput {
    @Field(type => Int)
    item_id: number
}