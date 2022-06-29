import {Field, ObjectType} from "type-graphql";

@ObjectType()
export class AccessType {
    @Field()
    accessToken: string

    @Field()
    publicKey: string
}