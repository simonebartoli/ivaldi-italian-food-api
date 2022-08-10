import {Field, InputType} from "type-graphql";
import {IsUUID} from "class-validator";

@InputType()
export class CreateRetrievePdfInput {
    @Field()
    @IsUUID(4)
    order_ref: string
}