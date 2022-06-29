import {FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {User} from "../../types/userType";
import {Cart} from "../../types/cartType";
import {Item} from "../../types/itemType";
import {UserInfo} from "../../custom-decorator/userInfo";

@Resolver(of => Cart)
export class CartFieldResolvers implements ResolverInterface<Cart>{

    @FieldResolver()
    async item(@Root() cart: Cart, @UserInfo() user: User): Promise<Item>{
        const {user_id} = user
        const result: [Item] = await prisma.$queryRaw`
            SELECT i.* FROM items i
            INNER JOIN carts c on i.item_id = c.item_id
            WHERE c.user_id = ${user_id} AND c.item_id = ${cart.item_id}
        `
        return result[0]
    }
}