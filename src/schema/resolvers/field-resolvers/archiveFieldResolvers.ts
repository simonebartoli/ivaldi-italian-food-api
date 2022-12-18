import {Ctx, FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import {Context} from "../../types/not-graphql/contextType";
import {Archive} from "../../types/archiveType";
import {ArchiveItem} from "../../types/archiveItemType";
import {ShippingAddress} from "../../types/shippingAddressType";
import {BillingAddress} from "../../types/billingAddressType";

@Resolver(of => Archive)
export class ArchiveFieldResolvers implements ResolverInterface<Archive>{

    @FieldResolver()
    items(@Root() archive: Archive, @Ctx() ctx: Context): ArchiveItem[] {
        const result: ArchiveItem[] = []
        for(const item of archive.items){
            result.push({
                item_id: item.item_id,
                name: item.name,
                amount: item.amount,
                vat: item.vat,
                price_total: item.price_total,
                photo_loc: item.photo_loc,
                price_per_unit: item.price_per_unit,
                price_unit: item.price_unit,
                weight: item.weight,
            })
        }
        return result
    }

    @FieldResolver()
    shipping_address(@Root() archive: Archive, @Ctx() ctx: Context): ShippingAddress {
        return {
            address_id: archive.shipping_address.address_id,
            first_address: archive.shipping_address.first_address,
            second_address: archive.shipping_address.second_address,
            postcode: archive.shipping_address.postcode,
            city: archive.shipping_address.city,
            notes: archive.shipping_address.notes,
            coordinates: archive.shipping_address.coordinates
        }
    }

    @FieldResolver()
    billing_address(@Root() archive: Archive, @Ctx() ctx: Context): BillingAddress {
        return {
            address_id: archive.billing_address.address_id,
            first_address: archive.billing_address.first_address,
            second_address: archive.billing_address.second_address,
            postcode: archive.billing_address.postcode,
            city: archive.billing_address.city,
            notes: archive.billing_address.notes,
            country: archive.billing_address.country,
            coordinates: archive.billing_address.coordinates
        }
    }
}