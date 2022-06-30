import {Field, Float, ID, ObjectType} from "type-graphql";
import {ReceiptArchive} from "./archiveType";
import {Order} from "./orderType";

@ObjectType()
export class Receipt {

    @Field(type => ID)
    receipt_id: number

    @Field(type => Float)
    price_total: number

    @Field(type => Float)
    vat: number

    @Field()
    datetime: Date

    @Field()
    payment_method: string

    @Field()
    archive: ReceiptArchive

    @Field(type => String)
    status: "COMPLETED" | "REFUNDED"

    @Field(type => Order)
    order?: Order

}