import {Field, Float, InputType} from "type-graphql";
import {IsUUID} from "class-validator";

@InputType()
export class OrderReceiptFilters {
    @Field(type => Float, {nullable: true})
    priceMin?: number

    @Field(type => Float, {nullable: true})
    priceMax?: number

    @Field({nullable: true})
    dateMin?: Date

    @Field({nullable: true})
    dateMax?: Date

    @IsUUID()
    @Field({nullable: true})
    order_ref?: string
}