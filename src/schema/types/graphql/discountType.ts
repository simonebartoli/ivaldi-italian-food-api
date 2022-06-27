import {Field, Float, ID, Int, ObjectType} from "type-graphql";

@ObjectType()
export class Discount {
    @Field(type => ID)
    discount_id: number

    @Field(type => Float)
    percentage: number

    @Field(type => String, {nullable: true})
    notes: string | null
}