import {Field, ID, Int, ObjectType} from "type-graphql";
import {User} from "./userType";

@ObjectType()
export class Token {

    @Field(type => ID)
    token_id: number

    @Field()
    secret: string

    @Field()
    expiry_datetime: Date

    @Field(type => User)
    user?: User

}