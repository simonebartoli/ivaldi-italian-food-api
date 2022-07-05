import {createMethodDecorator} from "type-graphql";
import {BAD_REQ_ERROR} from "../../errors/BAD_REQ_ERROR";
import {BAD_REQ_ERROR_ENUM} from "../enums/BAD_REQ_ERROR_ENUM";
import {
    verifyExtraPropertyRecoverToken,
    verifySignRecoverToken
} from "../lib/tokenVerificationLib";
import prisma from "../../db/prisma";
import Stripe from "stripe";

export function RequireValidRecoverToken() {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req, res} = context
        const stripe = <Stripe> context.stripe

        const token = req.cookies.recover_token
        if(token === undefined){
            throw new BAD_REQ_ERROR("User Needs to have a recover token", BAD_REQ_ERROR_ENUM.RECOVER_TOKEN_MISSING)
        }
        const recoverToken = await verifySignRecoverToken(token)
        await verifyExtraPropertyRecoverToken(recoverToken, context)

        res.clearCookie("recover_token")
        const {email_to_verify, id} = recoverToken
        if(email_to_verify){
            const result = await prisma.users.findUnique({
                where: {
                    user_id: id
                }
            })
            const stripe_result = await stripe.customers.create({
                email: result!.email_to_verify!,
                name: `${result!.name} ${result!.surname}`
            })

            await prisma.users.update({
                where: {
                    user_id: id
                },
                data: {
                    email_to_verify: null,
                    email: result!.email_to_verify,
                    stripe_customer_id: stripe_result.id
                }
            })
        }
        await prisma.recover_tokens.deleteMany({
            where: {
                user_id: id
            }
        })
        context.user_id = id
        return next();
    });
}