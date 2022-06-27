import {Field, InputType} from "type-graphql";
import {Length, Matches} from "class-validator";

@InputType()
export class ChangePasswordInput {
    @Field()
    @Length(8, 32)
    @Matches(/[a-zA-Z]/g)
    @Matches(/\d/g)
    newPassword: string
}