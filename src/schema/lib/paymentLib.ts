import {User} from "../types/userType";
import {Context} from "../types/not-graphql/contextType";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";
import {PAYMENT_ERROR} from "../../errors/PAYMENT_ERROR";
import {PAYMENT_ERROR_ENUM} from "../enums/PAYMENT_ERROR_ENUM";

export const getPaymentMethodIDFromFingerprint = async (fingerprint: string, user: User, ctx: Context): Promise<string | undefined> => {
    if (user.stripe_customer_id !== null) {
        const result = await ctx.stripe.customers.listPaymentMethods(
            user.stripe_customer_id,
            {type: "card"}
        )
        return result.data.find((element) =>
            element.card !== undefined && element.card.fingerprint === fingerprint
        )?.id
    }
    throw new INTERNAL_ERROR("Generic Error in Payment", INTERNAL_ERROR_ENUM.PAYMENT_ERROR)
}

export const verifyPaymentIntentFromID = async (payment_intent_id: string, user: User, ctx: Context) => {
    let result
    try{
        result = await ctx.stripe.paymentIntents.retrieve(payment_intent_id)
    }catch (e){
        throw new PAYMENT_ERROR("Payment Intent ID Not Valid", PAYMENT_ERROR_ENUM.PAYMENT_INTENT_NOT_VALID)
    }

    if(result.status === "succeeded" || result.status === "canceled"){
        throw new PAYMENT_ERROR("Payment Intent ID Not Valid", PAYMENT_ERROR_ENUM.PAYMENT_INTENT_NOT_VALID)
    }
    if(result.customer === null || result.customer !== user.stripe_customer_id){
        throw new PAYMENT_ERROR("Payment Intent ID Not Valid", PAYMENT_ERROR_ENUM.PAYMENT_INTENT_NOT_VALID)
    }
}