import {Field, Float, ID, Int, ObjectType} from "type-graphql";
import {Vat} from "./vatType";
import {Discount} from "./discountType";

@ObjectType()
export class Item {
    @Field(type => Float, {nullable: true})
    importance?: number

    @Field(type => ID)
    item_id: number

    @Field()
    name: string

    @Field()
    description: string

    @Field(type => Float)
    price_total: number

    @Field(type => Int)
    amount_available: number

    @Field()
    price_unit: string

    @Field()
    photo_loc: string

    @Field()
    entry_date: Date

    @Field(type => Boolean)
    priority: Boolean

    @Field(type => Int)
    weight: number

    @Field(type => [String])
    category?: string[]

    @Field(type => Vat)
    vat?: Vat

    @Field(type => Discount,{nullable: true})
    discount?: Discount

    @Field(type => [String!], {nullable: true})
    keywords?: string[]
}