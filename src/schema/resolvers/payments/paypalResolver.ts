import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {RequireValidAccessToken} from "../../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../../custom-decorator/userInfo";
import {User} from "../../types/userType";
import {Context} from "../../types/not-graphql/contextType";
import {CartInfo} from "../../custom-decorator/cartInfo";
import {Cart} from "../../types/cartType";
import {CreatePaymentIntentInput} from "../../inputs/createPaymentIntentInput";
import {
    calculateTotal, changeItemsAvailability,
    checkAndHashInformation, checkForHolidays, createPendingOrder, postPaymentOperations,
} from "../../lib/paymentLib";
import prisma from "../../../db/prisma";
import {DateTime} from "luxon";
import {countries} from "../../../countries";
import {capturePayment, createOrder, updateOrder} from "./paypal-api";
import {ConfirmPaymentInput} from "../../inputs/confirmPaymentInput";
import {DATA_ERROR} from "../../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../../enums/DATA_ERROR_ENUM";

@Resolver()
export class PaypalResolver {

    // TOTAL IS ALWAYS COMPREHENSIVE OF ITEMS_COST + VAT - DISCOUNT + SHIPPING

    @Mutation(returns => String)
    @RequireValidAccessToken()
    async createOrRetrievePaypalPaymentIntent(@UserInfo() user: User, @Ctx() ctx: Context, @CartInfo() cart: Cart[], @Arg("data") inputData: CreatePaymentIntentInput): Promise<string> {
        await checkForHolidays()

        const {shipping_address, billing_address, phone_number, delivery_suggested} = inputData

        let FOUND = false

        const {total} = await calculateTotal(cart)
        const hashToCheck = await checkAndHashInformation(ctx, inputData, cart, total, "PAYPAL")
        const resultHash = await prisma.payment_intents.findFirst({
            where: {
                hash: hashToCheck
            }
        })
        if(resultHash !== null){
            if(DateTime.fromJSDate(resultHash.expiry_datetime) < DateTime.now()){
                await prisma.payment_intents.delete({
                    where: {
                        payment_intent_id: resultHash.payment_intent_id
                    }
                })
            }else{
                FOUND = true
            }
        }
        if(FOUND) return resultHash!.payment_intent_id

        const purchaseUnits = [
            {
                amount: {
                    currency_code: "GBP",
                    value: String(total)
                },
                shipping: {
                    address: {
                        country_code: "GB",
                        address_line_1: shipping_address.first_address,
                        address_line_2: shipping_address.second_address,
                        admin_area_1: "",
                        admin_area_2: "London",
                        postal_code: shipping_address.postcode
                    },
                    name: {
                        full_name: `${user.name} ${user.surname}`
                    },
                    type: "SHIPPING"
                }
            }
        ]
        const payer = {
            email_address: user.email,
            address: {
                country_code: countries.find((element) => element.name === billing_address.country)!.code,
                address_line_1: billing_address.first_address,
                address_line_2: billing_address.second_address,
                admin_area_1: "",
                admin_area_2: " ",
                postal_code: billing_address.postcode
            },
            birth_date: DateTime.fromJSDate(user.dob).toISODate(),
            name: {
                given_name: user.name,
                surname: user.surname
            },
            // phone: {
            //     phone_number: {
            //         national_number: phone_number.replace(/\s/g, '')
            //     },
            //     phone_type: "MOBILE"
            // }
        }

        const result = await createOrder(purchaseUnits, payer)

        await prisma.payment_intents.create({
            data: {
                payment_intent_id: result.data.id,
                hash: hashToCheck,
                expiry_datetime: DateTime.now().plus({hour: 1}).toISO()
            }
        })

        const order = await createPendingOrder(ctx, cart, {
            payment_intent_id: result.data.id,
            phone_number: phone_number,
            billing_address: billing_address,
            shipping_address: shipping_address,
            delivery_suggested: delivery_suggested
        }, "PAYPAL")
        await updateOrder(result.data.id, String(order.receipt_number))

        return result.data.id
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async confirmPaypalPayment(@Ctx() ctx: Context, @Arg("data") inputData: ConfirmPaymentInput) {
        const {payment_intent_id} = inputData

        await changeItemsAvailability(payment_intent_id, "SUBTRACT")

        let result
        try{
            result = await capturePayment(payment_intent_id)
        }catch (e) {
            console.log(e)
            await changeItemsAvailability(payment_intent_id, "REVERT")
            throw new DATA_ERROR((e as Error).message, DATA_ERROR_ENUM.PAYMENT_METHOD_NOT_VALID)
        }

        // TODO Organise Post Payment Action - NO WEBHOOK
        await postPaymentOperations(payment_intent_id, ctx.user_id!, "PAYPAL", result.data.payer.payer_id)
        return true
    }
}
