import {Args, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {GetItemsPaginationArgs} from "../args/getItemsPaginationArgs";
import {GetItemsCursorArgs} from "../args/getItemsCursorArgs";
import {Category} from "../types/graphql/categoryType";

@Resolver()
export class CategoryResolvers {

    @Query(returns => [Category])
    async getCategories(): Promise<Category[]>{
        return await prisma.categories.findMany()
    }

    @Query(returns => [Category])
    async getCategories_pagination(@Args() {limit, offset}: GetItemsPaginationArgs): Promise<Category[]>{
        return await prisma.categories.findMany({
            skip: offset,
            take: limit
        })
    }

    @Query(returns => [Category])
    async getCategories_cursor(@Args() {cursor, limit}: GetItemsCursorArgs): Promise<Category[]>{
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