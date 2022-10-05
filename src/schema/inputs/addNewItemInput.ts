import {Field, Float, InputType, Int} from "type-graphql";
import {ArrayMinSize, Length, Max, Min} from "class-validator";

@InputType()
export class AddNewItemInput {
    @Field()
    @Length(3, 499)
    name: string

    @Field()
    @Length(10, 24999)
    description: string

    @Field(type => Float)
    @Min(0)
    price_total: number

    @Field( )
    @Length(0, 5)
    price_unit: string

    @Field(type => Int)
    @Min(0)
    @Max(999)
    amount_available: number

    @Field(type => Float)
    @Min(0)
    @Max(100)
    discount: number

    @Field(type => Float)
    vat: number

    @Field(type => [String])
    @ArrayMinSize(1)
    category: string[]

    @Field(type => [String])
    @ArrayMinSize(1)
    keyword: string[]

    @Field(type => String)
    photo_loc: string
}