import {Args, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {PaginationInterface} from "../args/paginationInterface";
import {CursorInterface} from "../args/cursorInterface";
import {Category} from "../types/categoryType";

@Resolver()
export class CategoryResolvers {

    @Query(returns => [Category])
    async getCategories_FULL(): Promise<Category[]>{
        return await prisma.categories.findMany()
    }

    // @Query(returns => [Category])
    async getCategories_pagination(@Args() {limit, offset}: PaginationInterface): Promise<Category[]>{
        return await prisma.categories.findMany({
            skip: offset,
            take: limit
        })
    }

    // @Query(returns => [Category])
    async getCategories_cursor(@Args() {cursor, limit}: CursorInterface): Promise<Category[]>{
        if(cursor === undefined || cursor === null){
            return await prisma.categories.findMany({
                take: limit
            })
        }
        return await prisma.categories.findMany({
            cursor: {
                category_id: cursor
            },
            skip: 1,
            take: limit
        })
    }

}