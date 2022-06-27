import {Field, InputType} from "type-graphql";
import {IsEmail, Length} from "class-validator";

@InputType()
export class ChangeEmailInput {
    @Field()
    @IsEmail()
    @Length(8, 64)
    newEmail: string
}