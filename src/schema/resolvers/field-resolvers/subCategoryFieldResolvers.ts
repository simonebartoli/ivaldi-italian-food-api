import {FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {Item} from "../../types/itemType";
import {SubCategory} from "../../types/subCategoryType";
import {Category} from "../../types/categoryType";

@Resolver(of => SubCategory)
export class SubCategoryFieldResolvers implements ResolverInterface<SubCategory>{

    @FieldResolver()
    async category(@Root() subCategory: SubCategory): Promise<Category>{
        const result: [Category] = await prisma.$queryRaw`
            SELECT categories.* FROM categories INNER JOIN sub_categories sc on categories.category_id = sc.category_id
            WHERE sc.sub_category_id = ${subCategory.sub_category_id}
        `
        return result[0]
    }

    @FieldResolver()
    async items(@Root() subCategory: SubCategory): Promise<Item[]>{
        return await prisma.$queryRaw`
            SELECT items.* FROM items INNER JOIN sub_categories_items sci on items.item_id = sci.item_id
            WHERE sci.sub_category_id = ${subCategory.sub_category_id}
        `
    }

}