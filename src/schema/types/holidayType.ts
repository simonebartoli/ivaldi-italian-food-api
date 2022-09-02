import {Field, ObjectType} from "type-graphql";

@ObjectType()
export class HolidayType {
    @Field(type => Date)
    start_date: Date

    @Field(type => Date)
    end_date: Date

    @Field(type => String, {nullable: true})
    reason?: string | null
}