import {Field, Float, ID, Int, ObjectType} from "type-graphql";
import {Vat} from "./vatType";
import {Discount} from "./discountType";

@ObjectType()
export class Item {
    @Field(type => ID)
    item_id: number

    @Field()
    name: string

    @Field()
    description: string

    @Field(type => Float)
    price: number

    @Field(type => Int)
    amount_available: number

    @Field()
    price_unit: string

    @Field()
    photo_loc: string

    @Field()
    entry_date: Date

    // @Field(type => [String])
    // category?: string[] | null

    @Field(type => Vat)
    vat?: Vat | null

    @Field(type => Discount,{nullable: true})
    discount?: Discount | null
}