import {ArgsType, Field, Float, InputType} from "type-graphql";

@InputType()
class Price{
    @Field(type => Float)
    min: number

    @Field(type => Float)
    max: number
}

@ArgsType()
export class GetItemsArgs {
    @Field(type => Boolean, {nullable: true})
    discountOnly?: boolean

    @Field(type => Boolean, {nullable: true})
    outOfStock?: boolean

    @Field(type => Price, {nullable: true})
    priceRange?: Price

    @Field(type => String)
    keywords: string

    @Field(type => String, {nullable: true})
    order?: "Most Relevant" | "Price Ascending" | "Price Descending" | "Higher Discounts"
}