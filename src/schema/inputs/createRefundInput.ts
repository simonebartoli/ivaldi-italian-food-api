import {Field, Float, InputType, Int} from "type-graphql";

@InputType()
class ArchiveRefundInput {
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

@InputType()
export class CreateRefundInput {
    @Field()
    reference: string

    @Field(type => [ArchiveRefundInput])
    archive: ArchiveRefundInput[]

    @Field()
    notes: string

    @Field(type => Boolean)
    shipping_cost: boolean
}
