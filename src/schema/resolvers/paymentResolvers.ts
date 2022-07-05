import {Arg, Ctx, Mutation, Query, Resolver} from "type-graphql";
import {PaymentIntent} from "../types/paymentIntentType";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../custom-decorator/userInfo";
import {User} from "../types/userType";
import {Context} from "../types/not-graphql/contextType";
import {PaymentMethod} from "../types/paymentMethodType";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";
import {ConfirmCardPaymentIntentInput} from "../inputs/confirmCardPaymentIntentInput";
import {getPaymentMethodIDFromFingerprint, verifyPaymentIntentFromID} from "../lib/paymentLib";
import {PAYMENT_ERROR} from "../../errors/PAYMENT_ERROR";
import {PAYMENT_ERROR_ENUM} from "../enums/PAYMENT_ERROR_ENUM";

@Resolver()
export class PaymentResolvers {

    @Mutation(returns => PaymentIntent)
    @RequireValidAccessToken()
    async createNewPaymentIntent(@UserInfo() user: User, @Ctx() ctx: Context): Promise<PaymentIntent>{
        const testAmount = 100 // 1 GBP
        const result = await ctx.stripe.paymentIntents.create({
            amount: testAmount,
            currency: "gbp",
            payment_method_types: ["card"],
            customer: user.stripe_customer_id as string,
            setup_future_usage: "on_session"
        })

        return {
            id: result.id,
            created: result.created,
            amount: result.amount,
            payment_method: null,
            client_secret: result.client_secret as string,
            currency: result.currency,
            status: result.status,
            customer: result.customer as string,
            setup_future_usage: result.setup_future_usage as "on_session"
        }
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async confirmPaymentIntent(@Arg("data") inputData: ConfirmCardPaymentIntentInput, @UserInfo() user: User, @Ctx() ctx: Context): Promise<boolean> {
        const payment_method_id: string | undefined = await getPaymentMethodIDFromFingerprint(inputData.card_fingerprint, user, ctx)
        if(payment_method_id === undefined){
            throw new PAYMENT_ERROR("Method Provided for Payment is Not Valid", PAYMENT_ERROR_ENUM.FINGERPRINT_NOT_VALID)
        }
        await verifyPaymentIntentFromID(inputData.payment_intent_id, user, ctx)

        // await ctx.stripe.paymentIntents.confirm(
        //     inputData.payment_intent_id,
        //     {payment_method: payment_method_id}
        // )

        return true
    }

    @Query(returns => [PaymentMethod])
    @RequireValidAccessToken()
    async getPaymentMethod(@UserInfo() user: User, @Ctx() ctx: Context): Promise<PaymentMethod[]> {
        if (user.stripe_customer_id !== null) {
            const result = await ctx.stripe.customers.listPaymentMethods(
                user.stripe_customer_id,
                {type: "card"}
            )
            const resultFormatted: PaymentMethod[] = []
            console.log(result)
            for(const element of result.data){
                resultFormatted.push({
                    fingerprint: element.card!.fingerprint!,
                    created: element.created,
                    customer: element.customer as string,
                    brand: element.card!.brand,
                    exp_month: element.card!.exp_month,
                    exp_year: element.card!.exp_year,
                    last4: element.card!.last4
                })
            }
            return resultFormatted
        }
        throw new INTERNAL_ERROR("Generic Error in Payment", INTERNAL_ERROR_ENUM.PAYMENT_ERROR)
    }
}