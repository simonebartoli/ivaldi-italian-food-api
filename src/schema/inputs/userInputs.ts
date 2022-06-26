import {Field, InputType} from "type-graphql";
import {User} from "../types/graphql/userType";
import {IsDate, IsEmail, Length, MaxDate, MinDate} from "class-validator";
import { DateTime } from "luxon";

@InputType()
export class CreateNewUseInputType implements Partial<User>{
    @Field()
    @Length(3, 24)
    name: string

    @Field()
    @Length(3, 24)
    surname: string

    @Field()
    @IsEmail()
    @Length(8, 64)
    email: string

    @Field()
    @IsDate()
    @MinDate(DateTime.now().minus({year: 100}).toJSDate())
    @MaxDate(DateTime.now().minus({year: 18}).toJSDate())
    dob: Date

    @Field()
    @Length(8, 32)
    // @Contains("a-zA-Z")
    // @Contains("/\\d/g")
    password: string
}