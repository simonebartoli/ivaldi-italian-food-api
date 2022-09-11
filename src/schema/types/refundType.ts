import {Field, Float, ID, Int, ObjectType} from "type-graphql";

@ObjectType()
class ArchiveRefund {
    @Field(type => Int)
    item_id: number

    @Field()
    name: string

    @Field(type => Int)
    amount_refunded: number

    @Field(type => Float)
    price_per_unit: number

    @Field(type => Float)
    price_total: number

    @Field(type => Float)
    taxes: number
}


@ObjectType()
export class Refund {
    @Field(type => ID)
    refund_id: number

    @Field(type => [ArchiveRefund])
    archive: ArchiveRefund[]

    @Field()
    notes: string

    @Field(type => Date)
    datetime: Date
}