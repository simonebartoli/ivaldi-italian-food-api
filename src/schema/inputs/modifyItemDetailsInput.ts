import {Field, Float, InputType, Int} from "type-graphql";
import {Length, Max, Min} from "class-validator";

@InputType()
export class ModifyItemDetailsInput {
    @Field(type => Int)
    item_id: number

    @Field({nullable: true})
    @Length(3, 49)
    name?: string

    @Field({nullable: true})
    @Length(10, 199)
    description?: string

    @Field(type => Float, {nullable: true})
    @Min(0)
    price_total?: number

    @Field( {nullable: true})
    @Length(0, 5)
    price_unit?: string

    @Field(type => Int, {nullable: true})
    @Min(0)
    @Max(999)
    amount_available?: number

    @Field(type => Float, {nullable: true})
    @Min(0)
    @Max(100)
    discount?: number

    @Field(type => Float, {nullable: true})
    vat?: number

    @Field(type => [String], {nullable: true})
    category?: string[]

    @Field(type => [String],{nullable: true})
    keyword?: string[]

    @Field(type => String, {nullable: true})
    photo_loc?: string
}