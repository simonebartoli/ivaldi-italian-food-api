import {Field, InputType} from "type-graphql";
import {IsEmail, Length} from "class-validator";

@InputType()
export class LoginWithPasswordInputs {

    @Field()
    @IsEmail()
    @Length(8, 64)
    email: string

    @Field()
    @Length(8, 32)
    password: string
}
