import {Field, InputType} from "type-graphql";
import {IsEmail, Length} from "class-validator";

@InputType()
export class LoginWithoutPasswordInputs {

    @Field()
    @IsEmail()
    @Length(8, 64)
    email: string

}
