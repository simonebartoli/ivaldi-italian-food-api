import {Field, Float, Int, ObjectType} from "type-graphql";

@ObjectType()
export class ArchiveItem {
    @Field()
    item_id: number

    @Field()
    name: string

    @Field(type => Float)
    price_total: number

    @Field(type => Float)
    price_per_unit: number

    @Field()
    photo_loc: string

    @Field()
    price_unit: string

    @Field(type => Int)
    amount: number

    @Field(type => Float)
    vat: number

    @Field(type => Int)
    weight: number
}