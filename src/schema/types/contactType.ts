import {Field, ID, ObjectType} from "type-graphql";
import {CONTACT_STATUS_ENUM} from "../enums/CONTACT_STATUS_ENUM";

@ObjectType()
export class ContactType {
    @Field(type => ID)
    contact_id: number

    @Field()
    name: string

    @Field()
    surname: string

    @Field()
    email: string

    @Field()
    phone_number: string

    @Field()
    message: string

    @Field(type => CONTACT_STATUS_ENUM)
    status: CONTACT_STATUS_ENUM
}