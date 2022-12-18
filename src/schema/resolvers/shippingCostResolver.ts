import {Query, Resolver} from "type-graphql";
import prisma from "../../db/prisma";
import {ShippingCost} from "../types/shippingCostType";

@Resolver()
export class ShippingCostResolver {
    @Query(returns => [ShippingCost])
    async getShippingCosts(): Promise<ShippingCost[]> {
        return await prisma.shipping_costs.findMany()
    }
}