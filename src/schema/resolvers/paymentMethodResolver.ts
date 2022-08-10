import {Ctx, Query, Resolver} from "type-graphql";
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {Context} from "../types/not-graphql/contextType";
import {UserInfo} from "../custom-decorator/userInfo";
import {User} from "../types/userType";
import {PaymentMethod} from "../types/paymentMethodType";
import {DateTime} from "luxon";

@Resolver()
export class PaymentMethodResolver {

    // RESOLVER CUSTOM FOR ARCHIVE ITEMS

    @Query(returns => [PaymentMethod])
    @RequireValidAccessToken()
    async getPaymentMethods(@Ctx() ctx: Context, @UserInfo() user: User): Promise<PaymentMethod[]> {
        const savedCard: PaymentMethod[] = []
        const {stripe_customer_id} = user
        const result = await ctx.stripe.customers.listPaymentMethods(stripe_customer_id!, {type: "card"})
        for(const card of result.data){
            const exp_date = DateTime.fromFormat(`${card.card!.exp_month} ${card.card!.exp_year}`, "M yyyy")
            if(DateTime.now() < exp_date){
                savedCard.push({
                    payment_method_id: card.id,
                    last4: card.card!.last4,
                    exp_date: exp_date.toISO(),
                    brand: card.card!.brand
                })
            }
        }
        return savedCard
    }

}