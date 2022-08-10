import {Field, ObjectType} from "type-graphql";

@ObjectType()
export class PaymentMethodDB {
    @Field()
    reference: string

    @Field()
    type: string

    @Field()
    account: string
}