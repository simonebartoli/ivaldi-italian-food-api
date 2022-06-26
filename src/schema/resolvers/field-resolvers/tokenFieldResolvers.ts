import {FieldResolver, Resolver, Root} from "type-graphql";
import {Token} from "../../types/graphql/tokenType";
import prisma from "../../../db/prisma";
import {User} from "../../types/graphql/userType";

@Resolver(of => Token)
export class TokenFieldResolvers {

    @FieldResolver()
    async user(@Root() token: Token): Promise<User>{
        return await prisma.users.findUnique({
            where: {
                user_id: token.user_id
            },
            rejectOnNotFound: true
        })
    }
}