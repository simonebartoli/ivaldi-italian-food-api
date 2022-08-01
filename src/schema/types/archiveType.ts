import {Field, ObjectType} from "type-graphql";
import {ShippingAddress} from "./shippingAddressType";
import {BillingAddress} from "./billingAddressType";
import {ArchiveItem} from "./archiveItemType";

@ObjectType()
export class Archive {
    @Field()
    billing_address: BillingAddress

    @Field()
    shipping_address: ShippingAddress

    @Field(type => [ArchiveItem])
    items: ArchiveItem[]
}