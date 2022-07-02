import {Field, InputType} from "type-graphql";
import {Length} from "class-validator";

@InputType()
export class ChangeRecoverTokenStatusInputs {
    @Field()
    @Length(64, 64)
    secret: string
}
