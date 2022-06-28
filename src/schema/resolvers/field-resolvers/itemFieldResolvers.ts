import {FieldResolver, Resolver, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {Item} from "../../types/graphql/itemType";
import {Vat} from "../../types/graphql/vatType";
import {Discount} from "../../types/graphql/discountType";

@Resolver(of => Item)
export class ItemFieldResolvers {

    @FieldResolver()
    async vat(@Root() item: Item): Promise<Vat>{
        const result: Vat[] = await prisma.$queryRaw`
            SELECT vat.* FROM vat INNER JOIN items i on vat.vat_id = i.vat_id WHERE i.item_id = ${item.item_id}
        `
        return result[0]!
    }

    @FieldResolver()
    async discount(@Root() item: Item): Promise<Discount | null>{
        const result: Discount[] = await prisma.$queryRaw`
            SELECT discounts.* FROM discounts INNER JOIN items i on discounts.discount_id = i.discount_id WHERE i.item_id = ${item.item_id}
        `
        return result.length === 0 ? null : result[0]!
    }

    // @FieldResolver()
    // async category(@Root() item: Item): Promise<string[]>{
    //     const categories = await prisma.categories_items.findMany({
    //         select: {
    //             ca
    //         }
    //         where: {
    //             item_id: item.item_id
    //         }
    //     })
    // }

}