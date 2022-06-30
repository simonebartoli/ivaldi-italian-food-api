import {Field, Float, ID, ObjectType} from "type-graphql";

@ObjectType()
export class Vat {
    @Field(type => ID)
    vat_id: number

    @Field(type => Float)
    percentage: number
}