import {Field, InputType, Int} from "type-graphql";

@InputType()
export class ConfirmDeliveryInput {
    @Field()
    reference: string

    @Field(type => Date)
    datetime: Date
}