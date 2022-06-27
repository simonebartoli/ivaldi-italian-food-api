import {Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {Item} from "../types/graphql/itemType";

@Resolver()
export class ItemResolvers {

    @Query(returns => [Item])
    async getItems_FULL(): Promise<Item[]>{
        return prisma.items.findMany()
    }

}