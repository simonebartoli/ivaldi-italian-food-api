import {Field, ObjectType} from "type-graphql";
import {ShippingAddress} from "./shippingAddressType";
import {BillingAddress} from "./billingAddressType";
import {ArchiveItem} from "./archiveItemType";

@ObjectType()
class Archive {
    @Field(type => [ArchiveItem])
    item: ArchiveItem[]
}

@ObjectType()
export class OrderArchive extends Archive{
    @Field()
    shipping_address: ShippingAddress
}

@ObjectType()
export class ReceiptArchive extends Archive{
    @Field()
    billing_address: BillingAddress
}