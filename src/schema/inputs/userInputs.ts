import {Field, InputType} from "type-graphql";
import {User} from "../types/userType";
import {IsEmail, Length} from "class-validator";

@InputType()
export class CreateNewUseInputType implements Partial<User>{
    @Field()
    @Length(3, 20)
    name: string

    @Field()
    @Length(3, 20)
    surname: string

    @Field()
    @IsEmail()
    email: string

    @Field()
    dob: Date

    @Field()
    @Length(8, 32)
    password: string
}