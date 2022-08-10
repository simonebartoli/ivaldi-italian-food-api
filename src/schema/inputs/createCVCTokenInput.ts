import {Field, InputType} from "type-graphql";
import {IsNumberString, Length} from "class-validator";

@InputType()
export class CreateCVCTokenInput {
    @Field()
    @IsNumberString()
    @Length(3, 4)
    cvc: string
}