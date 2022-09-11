import {Field, InputType} from "type-graphql";

@InputType()
export class CreateTimeslotDeliveryInput {
    @Field()
    reference: string

    @Field()
    timeslot: string
}