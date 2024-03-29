import {FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {Item} from "../../types/itemType";
import {Vat} from "../../types/vatType";
import {Discount} from "../../types/discountType";

@Resolver(of => Item)
export class ItemFieldResolvers implements ResolverInterface<Item>{

    @FieldResolver()
    async vat(@Root() item: Item): Promise<Vat>{
        const result: [Vat] = await prisma.$queryRaw`
            SELECT vat.* FROM vat INNER JOIN items i on vat.vat_id = i.vat_id WHERE i.item_id = ${item.item_id}
        `
        return result[0]
    }

    @FieldResolver()
    async discount(@Root() item: Item): Promise<Discount>{
        const result: [Discount] = await prisma.$queryRaw`
            SELECT discounts.* FROM discounts INNER JOIN items i on discounts.discount_id = i.discount_id WHERE i.item_id = ${item.item_id}
        `
        return result[0]
    }

    @FieldResolver()
    async category(@Root() item: Item): Promise<string[]>{
        type result = {name: string}

        const resultCategory: result[] = await prisma.$queryRaw`
            SELECT c.name FROM categories c
            INNER JOIN categories_items ci on c.category_id = ci.category_id
            INNER JOIN items i on i.item_id = ci.item_id
            WHERE i.item_id = ${item.item_id}
        `
        const resultSubCategory: result[] = await prisma.$queryRaw`
            SELECT sub_c.name FROM sub_categories sub_c
            INNER JOIN sub_categories_items sci on sub_c.sub_category_id = sci.sub_category_id
            INNER JOIN items i on i.item_id = sci.item_id
            WHERE i.item_id = ${item.item_id}
        `
        return [...resultCategory, ...resultSubCategory].map(element => element.name)
    }

    @FieldResolver()
    async keywords(@Root() item: Item): Promise<string[]> {
        const result = await prisma.keywords.findMany({
            where: {
                item_id: item.item_id
            }
        })
        return result.map(element => element.keyword)
    }

}