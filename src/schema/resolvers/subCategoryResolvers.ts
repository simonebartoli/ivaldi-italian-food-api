import {Args, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {PaginationInterface} from "../args/paginationInterface";
import {CursorInterface} from "../args/cursorInterface";
import {SubCategory} from "../types/subCategoryType";

@Resolver()
export class SubCategoryResolvers {

    @Query(returns => [SubCategory])
    async getSubCategories_FULL(): Promise<SubCategory[]>{
        return await prisma.sub_categories.findMany()
    }

    @Query(returns => [SubCategory])
    async getSubCategories_pagination(@Args() {limit, offset}: PaginationInterface): Promise<SubCategory[]>{
        return await prisma.sub_categories.findMany({
            skip: offset,
            take: limit
        })
    }

    @Query(returns => [SubCategory])
    async getSubCategories_cursor(@Args() {cursor, limit}: CursorInterface): Promise<SubCategory[]>{
        if(cursor === undefined || cursor === null){
            return await prisma.sub_categories.findMany({
                take: limit
            })
        }
        return await prisma.sub_categories.findMany({
            cursor: {
                sub_category_id: cursor
            },
            skip: 1,
            take: limit
        })
    }

}