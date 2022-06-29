import {Query, Resolver} from "type-graphql";
import {Cart} from "../types/cartType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../custom-decorator/userInfo";
import {User} from "../types/userType";
import prisma from "../../db/prisma";

@Resolver()
export class CartResolver {

    @Query(returns => [Cart])
    @RequireValidAccessToken()
    async getUserCart(@UserInfo() user: User): Promise<Cart[]>{
        const {user_id} = user
        return await prisma.carts.findMany({
            where: {
                user_id: user_id
            }
        })
    }
}