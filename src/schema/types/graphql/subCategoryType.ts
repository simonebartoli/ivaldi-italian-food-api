import {Field, Float, ID, Int, ObjectType} from "type-graphql";
import {Category} from "./categoryType";
import {Item} from "./itemType";

@ObjectType()
export class SubCategory {
    @Field(type => ID)
    sub_category_id: number

    @Field()
    name: string

    @Field(type => String, {nullable: true})
    notes: string | null

    @Field(type => Category)
    category?: Category | null

    @Field(type => [Item], {nullable: true})
    items?: Item[] | null
}