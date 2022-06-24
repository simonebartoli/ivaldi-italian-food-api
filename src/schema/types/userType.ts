import {Field, ID, ObjectType} from "type-graphql";

@ObjectType()
export class User {
    @Field(type => ID)
    user_id: number

    @Field()
    name: string

    @Field()
    surname: string

    @Field()
    email: string

    @Field()
    dob: Date

    @Field()
    role: string
}