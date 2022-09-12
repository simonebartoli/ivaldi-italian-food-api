import {Field, InputType} from "type-graphql";

@InputType()
export class CreateNewHolidayInput {
    @Field(type => Date)
    start_date: Date

    @Field(type => Date)
    end_date: Date
}