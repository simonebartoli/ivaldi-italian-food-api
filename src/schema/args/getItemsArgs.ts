import {ArgsType, Field, Float, InputType} from "type-graphql";

@InputType()
class Filter{
    @Field(type => [String])
    keywords: string[]

    @Field(type => [String])
    categories: string[]
}

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

    @Field(type => Filter, {nullable: true})
    filter?: Filter
}