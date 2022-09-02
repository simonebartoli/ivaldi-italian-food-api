import {capturePayment} from "../schema/resolvers/payments/paypal-api";
import express from "express";

export const paypalRouter = express.Router()
paypalRouter.post("/api/orders", async (req, res) => {

    // const order = await createOrder();
    res.json(req.body);
});

// capture payment & store order information or fullfill order

paypalRouter.post("/api/orders/:orderID/capture", async (req, res) => {
    const { orderID } = req.params;
    const captureData = await capturePayment(orderID);

    // TODO: store payment information such as the transaction ID

    res.json(captureData);

});