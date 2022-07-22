import {FieldResolver, Resolver, ResolverInterface, Root} from "type-graphql";
import prisma from "../../../db/prisma";
import {User} from "../../types/userType";
import {ShippingAddress} from "../../types/shippingAddressType";
import {BillingAddress} from "../../types/billingAddressType";
import {Cart} from "../../types/cartType";

@Resolver(of => User)
export class UserFieldResolvers implements ResolverInterface<User> {

    @FieldResolver()
    async shipping_addresses(@Root() user: User): Promise<ShippingAddress[]> {
        return await prisma.$queryRaw`
            SELECT a.*, sa.*
            FROM addresses a
            INNER JOIN shipping_addresses sa on a.address_id = sa.address_id
            WHERE a.user_id = ${user.user_id}
            ORDER BY a.address_id DESC 
        `
    }

    @FieldResolver()
    async billing_addresses(@Root() user: User): Promise<BillingAddress[]> {
        return await prisma.$queryRaw`
            SELECT a.*, ba.*
            FROM addresses a
            INNER JOIN billing_addresses ba on a.address_id = ba.address_id
            WHERE a.user_id = ${user.user_id}
            ORDER BY a.address_id DESC 
        `
    }

    @FieldResolver()
    async cart(@Root() user: User): Promise<Cart[]> {
        return await prisma.$queryRaw`
            SELECT c.*
            FROM carts c
            INNER JOIN users u on c.user_id = u.user_id
            WHERE u.user_id = ${user.user_id}
        `
    }
}