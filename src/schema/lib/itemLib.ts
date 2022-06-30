import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import {Item} from "../types/itemType";

export const verifyItemExisting = async (item_id: number): Promise<Item> => {
    const item = await prisma.items.findUnique({
        where: {
            item_id: item_id
        }
    })
    if(item === null){
        throw new DATA_ERROR("Item Not Existing", DATA_ERROR_ENUM.ITEM_NOT_EXISTING)
    }
    return item
}

export const verifyItemAvailability = async (amount: number, item: Item) => {
    if(amount > item.amount_available){
        throw new DATA_ERROR("Amount is more than the one available", DATA_ERROR_ENUM.AMOUNT_NOT_AVAILABLE)
    }
}