import {FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {Item} from "../../types/itemType";
import {SubCategory} from "../../types/subCategoryType";
import {Category} from "../../types/categoryType";

@Resolver(of => Category)
export class CategoryFieldResolvers implements ResolverInterface<Category>{

    @FieldResolver()
    async sub_categories(@Root() category: Category): Promise<SubCategory[]>{
        return await prisma.$queryRaw`
            SELECT sc.* FROM sub_categories sc INNER JOIN categories c on c.category_id = sc.category_id WHERE sc.category_id = ${category.category_id}
        `
    }

    @FieldResolver()
    async items(@Root() category: Category): Promise<Item[]>{
        return await prisma.$queryRaw`
            SELECT items.* from items INNER JOIN categories_items ci on items.item_id = ci.item_id where ci.category_id = ${category.category_id}
        `
    }

}