import {Field, Int, ObjectType} from "type-graphql";
import {Item} from "./itemType";

@ObjectType()
export class Cart {
    @Field(type => Int)
    amount: number

    @Field(type => Item)
    item?: Item

    @Field(type => Int)
    item_id: number
}