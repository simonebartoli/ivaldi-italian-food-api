import {Field, InputType} from "type-graphql";
import {IsEmail, IsString, Length} from "class-validator";

@InputType()
export class CreateNewContactRequestInput {
    @Field()
    @IsString()
    name: string

    @Field()
    @IsString()
    surname: string

    @Field()
    @IsEmail()
    email: string

    @Field()
    phone_number: string

    @Field()
    @IsString()
    @Length(51, 499)
    message: string
}