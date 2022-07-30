import {createParamDecorator} from "type-graphql";
import prisma from "../../db/prisma";
import {Cart} from "../types/cartType";

export function CartInfo() {
    return createParamDecorator(async ({context}: any): Promise<Cart[]> => {
        const user_id = context.user_id
        const cart = await prisma.carts.findMany({
            include: {
                items: true
            },
            where: {
                user_id: user_id,
                items: {
                    amount_available: {
                        gt: 0
                    }
                }
            }
        })
        return cart.filter((element) => element.amount <= element.items.amount_available)
    });
}