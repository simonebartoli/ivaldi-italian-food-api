import {Query, Resolver} from "type-graphql";
import {Token} from "../types/graphql/tokenType";
import prisma from "../../db/prisma";

@Resolver(of => Token)
export class TokenResolvers {

    @Query(returns => [Token])
    async getAllToken(): Promise<Token[]> {
        return await prisma.tokens.findMany()
    }

}