import {Arg, Ctx, Mutation, Query, Resolver} from "type-graphql";
import {Cart} from "../types/cartType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import prisma from "../../db/prisma";
import {CartInfo} from "../custom-decorator/cartInfo";
import {AddEntryToCartInput} from "../inputs/addEntryToCartInput";
import {verifyItemAvailability, verifyItemExisting} from "../lib/itemLib";
import {Context} from "../types/not-graphql/contextType";
import {RemoveEntryFromCartInput} from "../inputs/removeEntryFromCartInput";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";

@Resolver()
export class CartResolver {

    @Query(returns => [Cart])
    @RequireValidAccessToken()
    async getUserCart(@Ctx() ctx: Context): Promise<Cart[]>{
        const {user_id} = ctx
        return await prisma.carts.findMany({
            where: {
                user_id: user_id!
            }
        })
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async addNewRecord(@Ctx() ctx: Context, @CartInfo() cart: Cart[], @Arg("data") inputData: AddEntryToCartInput): Promise<boolean> {
        const {user_id} = ctx
        const {item_id, amount} = inputData
        await verifyItemAvailability(item_id, await verifyItemExisting(amount))
        const result = await prisma.carts.findUnique({
            where: {
                user_id_item_id: {
                    item_id: item_id,
                    user_id: user_id!
                }
            }
        })
        if(result === null)
            await prisma.carts.create({
                data: {
                    item_id: item_id,
                    user_id: user_id!,
                    amount: amount
                }
            })
        else
            await prisma.carts.update({
                where: {
                    user_id_item_id: {
                        item_id: item_id,
                        user_id: user_id!
                    }
                },
                data: {
                    amount: {
                        increment: amount
                    }
                }
            })

        return true
    }


    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async removeRecord(@Ctx() ctx: Context, @CartInfo() cart: Cart[], @Arg("data") inputData: RemoveEntryFromCartInput): Promise<boolean> {
        const {user_id} = ctx
        const {item_id, amount} = inputData
        const cartItem = cart.find((element) => element.item_id === item_id)
        if(cartItem === undefined){
            throw new DATA_ERROR("This item does not exist in your cart", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
        }

        if(amount === undefined || amount === null || amount >= cartItem.amount){
            await prisma.carts.delete({
                where: {
                    user_id_item_id: {
                        item_id: item_id,
                        user_id: user_id!
                    }
                }
            })
        }else{
            await prisma.carts.update({
                where: {
                    user_id_item_id: {
                        item_id: item_id,
                        user_id: user_id!
                    }
                },
                data: {
                    amount: {
                        decrement: amount
                    }
                }
            })
        }

        return true
    }

}