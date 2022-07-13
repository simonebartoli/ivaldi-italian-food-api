import express, {Request, Response} from "express";
import Stripe from "stripe";
import {STRIPE_SECRET_KEY} from "../bin/settings";
const stripe = new Stripe(STRIPE_SECRET_KEY, {apiVersion: '2020-08-27'})

const endpointSecret = "whsec_09fa8d4a1477e77900deef5772189516c54a97d1fc76e91718afa13078d2d952";

export const webhookRouter = express.Router()
webhookRouter.post("/webhook", express.raw({type: 'application/json'}), (req: Request, res: Response) => {
    const sig: any = req.headers['stripe-signature'];

    let event;

    try {
        event = stripe.webhooks.constructEvent(req.body, sig, endpointSecret);
    } catch (err: any) {
        res.status(400).send(`Webhook Error: ${err.message}`);
        return;
    }
    switch (event.type) {
        case 'payment_intent.succeeded':
            const paymentIntent = event.data.object;
            console.log('PaymentIntent was successful!');
            break;
        case 'payment_method.attached':
            const paymentMethod = event.data.object;
            console.log('PaymentMethod was attached to a Customer!');
            break;
        // ... handle other event types
        default:
            console.log(`Unhandled event type ${event.type}`);
    }

    // Return a response to acknowledge receipt of the event
    res.json({received: true});
})