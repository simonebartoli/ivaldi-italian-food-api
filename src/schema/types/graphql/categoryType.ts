import {Field, Float, ID, Int, ObjectType} from "type-graphql";
import {Item} from "./itemType";
import {SubCategory} from "./subCategoryType";

@ObjectType()
export class Category {
    @Field(type => ID)
    category_id: number

    @Field()
    name: string

    @Field(type => String, {nullable: true})
    notes: string | null

    @Field(type => [SubCategory], {nullable: true})
    sub_categories?: SubCategory[] | null

    @Field(type => [Item], {nullable: true})
    items?: Item[] | null
}