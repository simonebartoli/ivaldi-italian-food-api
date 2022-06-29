import {FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import {Token} from "../../types/tokenType";
import prisma from "../../../db/prisma";
import {User} from "../../types/userType";

@Resolver(of => Token)
export class TokenFieldResolvers implements ResolverInterface<Token>{

    @FieldResolver()
    async user(@Root() token: Token): Promise<User>{
        const result: [User] = await prisma.$queryRaw`
            SELECT users.* FROM users INNER JOIN refresh_tokens rt on users.user_id = rt.user_id 
            WHERE rt.token_id = ${token.token_id}
        `
        return result[0]
    }
}