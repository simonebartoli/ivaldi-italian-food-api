import {Arg, Args, Ctx, Mutation, Query, Resolver} from "type-graphql";
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
import {ItemCart} from "../inputs/itemCart";
import {Item} from "../types/itemType";

@Resolver()
export class CartResolver {

    @Query(returns => [Cart])
    @RequireValidAccessToken()
    async getUserCart(@Ctx() ctx: Context): Promise<Cart[]>{
        const {user_id} = ctx
        const result: Cart[] = []

        const cart = await prisma.carts.findMany({
            include: {
                items: true
            },
            where: {
                user_id: user_id!
            }
        })
        for(const cartElement of cart){
            const amountSelected = cartElement.amount
            const amountAvailable = cartElement.items.amount_available

            if(amountSelected > amountAvailable && amountAvailable > 0){
                await prisma.carts.update({
                    where: {
                        user_id_item_id: {
                            user_id: user_id!,
                            item_id: cartElement.item_id
                        }
                    },
                    data: {
                        amount: amountAvailable
                    }
                })
                result.push({
                    amount: amountAvailable,
                    item_id: cartElement.item_id
                })
            }else if(amountAvailable === 0){
                await prisma.carts.delete({
                    where: {
                        user_id_item_id: {
                            user_id: user_id!,
                            item_id: cartElement.item_id
                        }
                    }
                })
            }else{
                result.push({
                    amount: amountSelected,
                    item_id: cartElement.item_id
                })
            }
        }
        return result
    }


    @Query(returns => [Item])
    async getItemsCart(@Arg("items", returns => [ItemCart]) items: ItemCart[]): Promise<Item[]> {
        const items_id = items.map((element) => element.item_id)
        return await prisma.items.findMany({
            where: {
                item_id: {
                    in: items_id
                },
                amount_available: {
                    gt: 0
                }
            }
        })
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async addNewRecord(@Ctx() ctx: Context, @CartInfo() cart: Cart[], @Arg("data") inputData: AddEntryToCartInput): Promise<boolean> {
        const {user_id} = ctx
        const {item_id, amount} = inputData
        await verifyItemAvailability(amount, await verifyItemExisting(item_id))
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


    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async syncCarts(@Ctx() ctx: Context, @CartInfo() cart: Cart[], @Arg("data", returns => [AddEntryToCartInput]) inputData: AddEntryToCartInput[]): Promise<boolean> {
        const cartExistingMap = new Map<number, number>()

        for(const cartExistingElement of cart){
            cartExistingMap.set(cartExistingElement.item_id, cartExistingElement.amount)
        }

        for(const inputDataElement of inputData){
            if(!cartExistingMap.has(inputDataElement.item_id)){
                await prisma.carts.create({
                    data: {
                        item_id: inputDataElement.item_id,
                        amount: inputDataElement.amount,
                        user_id: ctx.user_id!
                    }
                })
            }else{
                await prisma.carts.update({
                    where: {
                        user_id_item_id: {
                            item_id: inputDataElement.item_id,
                            user_id: ctx.user_id!
                        }
                    },
                    data: {
                        amount: inputDataElement.amount,
                    }
                })
            }
        }
        return true
    }

    // @Query(returns => Boolean)
    // async checkItemAvailability(@Args() {item_id, amount}: ItemCart): Promise<boolean> {
    //     await verifyItemAvailability(amount, await verifyItemExisting(item_id))
    //     return true
    // }
}