import express, {Request, Response} from "express";
import Stripe from "stripe";
import {STRIPE_SECRET_KEY} from "../bin/settings";
import {WEBHOOK_SECRET_KEY} from "../bin/settings";
import prisma from "../db/prisma";
import {ORDER_STATUS_ENUM} from "../schema/enums/ORDER_STATUS_ENUM";

const stripe = new Stripe(STRIPE_SECRET_KEY, {apiVersion: '2020-08-27'})

export const webhookRouter = express.Router()
webhookRouter.post("/webhook", express.raw({type: 'application/json'}), async (req: Request, res: Response) => {
    const sig: any = req.headers['stripe-signature'];

    let event;

    console.log("PASS HERE")
    try {
        event = stripe.webhooks.constructEvent(req.body, sig, WEBHOOK_SECRET_KEY);
    } catch (err: any) {
        res.status(400).send(`Webhook Error: ${err.message}`);
        return;
    }
    if (event.type === "payment_intent.succeeded") {
        await handlePaymentSucceeded(event)
        console.log('PaymentIntent was successful!');
    }

    // Return a response to acknowledge receipt of the event
    res.json({received: true});
})

const handlePaymentSucceeded = async (event: Stripe.Event) => {
    const {data: {object: paymentInfo}} = event
    console.log(paymentInfo)
    const paymentIntentID = (paymentInfo as Stripe.PaymentIntent).id

    try{
        const order = await prisma.orders.findUniqueOrThrow({where: {order_id: paymentIntentID}})
        const paymentMethodID = (paymentInfo as Stripe.PaymentIntent).payment_method as string
        const paymentMethod = await stripe.paymentMethods.retrieve(paymentMethodID)
        const last4 = paymentMethod.card!.last4

        const result = await prisma.orders.update({
            select: {
                reference: true
            },
            data: {
                status: ORDER_STATUS_ENUM.CONFIRMED
            },
            where: {
                order_id: paymentIntentID
            }
        })

        const user_id = order.user_id

        await prisma.payment_intents.delete({
            where: {
                payment_intent_id: paymentIntentID
            }
        })
        await prisma.items_hold.deleteMany({where: {payment_intent_id: paymentIntentID}})
        await prisma.carts.deleteMany({where: {user_id: user_id}})
        await prisma.payment_methods.create({
            data: {
                reference: result.reference,
                type: "CARD",
                account: last4
            }
        })
    }catch (e) {
        console.log("ORDER NOT FOUND: " + paymentIntentID)
    }
}