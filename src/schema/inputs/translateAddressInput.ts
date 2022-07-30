import {Field, InputType, Int} from "type-graphql";
import {ADDRESS_TYPE_ENUM} from "../enums/ADDRESS_TYPE_ENUM";

@InputType()
export class TranslateAddressInput {
    @Field(type => Int)
    address_id: number

    @Field(type => ADDRESS_TYPE_ENUM)
    destination: ADDRESS_TYPE_ENUM
}