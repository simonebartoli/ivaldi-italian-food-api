import {FieldResolver, Resolver, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {Item} from "../../types/graphql/itemType";
import {Vat} from "../../types/graphql/vatType";
import {Discount} from "../../types/graphql/discountType";

@Resolver(of => Item)
export class ItemFieldResolvers {

    @FieldResolver()
    async vat(@Root() item: Item): Promise<Vat>{
        return await prisma.vat.findUnique({
            where: {
                vat_id: item.vat_id
            },
            rejectOnNotFound: true
        })
    }

    @FieldResolver()
    async discount(@Root() item: Item): Promise<Discount | null>{
        if(item.discount_id === null){
            return null
        }
        return await prisma.discounts.findUnique({
            where: {
                discount_id: item.discount_id
            },
            rejectOnNotFound: true
        })
    }

}