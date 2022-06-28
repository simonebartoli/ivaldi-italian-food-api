import {FieldResolver, Resolver, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {Item} from "../../types/graphql/itemType";
import {SubCategory} from "../../types/graphql/subCategoryType";
import {Category} from "../../types/graphql/categoryType";

@Resolver(of => Category)
export class CategoryFieldResolvers {

    @FieldResolver()
    async sub_categories(@Root() category: Category): Promise<SubCategory[] | null>{
        const result: SubCategory[] = await prisma.$queryRaw`
            SELECT sc.* FROM sub_categories sc INNER JOIN categories c on c.category_id = sc.category_id WHERE sc.category_id = ${category.category_id}
        `
        return result.length === 0 ? null : result
    }

    @FieldResolver()
    async items(@Root() category: Category): Promise<Item[] | null>{
        const result: Item[] = await prisma.$queryRaw`
            SELECT items.* from items INNER JOIN categories_items ci on items.item_id = ci.item_id where ci.category_id = ${category.category_id}
        `
        return result.length === 0 ? null : result
    }

}