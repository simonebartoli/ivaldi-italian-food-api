import {createParamDecorator} from "type-graphql";
import prisma from "../../db/prisma";
import {Cart} from "../types/cartType";

export function CartInfo() {
    return createParamDecorator(async ({context}: any): Promise<Cart[]> => {
        const user_id = context.user_id
        return await prisma.carts.findMany({
            where: {
                user_id: user_id
            }
        })
    });
}