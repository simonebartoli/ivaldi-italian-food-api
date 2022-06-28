import {Arg, Args, Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {Item} from "../types/graphql/itemType";
import {GetItemsPaginationArgs} from "../args/getItemsPaginationArgs";
import {GetItemsCursorArgs} from "../args/getItemsCursorArgs";

@Resolver()
export class ItemResolvers {

    @Query(returns => [Item])
    async getItems_FULL(): Promise<Item[]>{
        return await prisma.items.findMany()
    }

    @Query(returns => [Item])
    async getItems_pagination(@Args() {limit, offset}: GetItemsPaginationArgs): Promise<Item[]>{
        return await prisma.items.findMany({
            skip: offset,
            take: limit
        })
    }

    @Query(returns => [Item])
    async getItems_cursor(@Args() {cursor, limit}: GetItemsCursorArgs): Promise<Item[]>{
        if(cursor === undefined || cursor === null){
            return await prisma.items.findMany({
                take: limit
            })
        }
        return await prisma.items.findMany({
            cursor: {
                item_id: cursor
            },
            skip: 1,
            take: limit
        })
    }

}