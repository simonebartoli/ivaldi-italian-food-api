import axios, {AxiosResponse} from "axios";

import { PAYPAL_CLIENT_ID, PAYPAL_SECRET } from "../../../bin/settings";
const base = "https://api-m.sandbox.paypal.com";

export async function createOrder() {
    const accessToken = await generateAccessToken();
    const url = `${base}/v2/checkout/orders`;
    const response = await axios.post(url, {
        headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
            intent: "CAPTURE",
            purchase_units: [
                {
                    amount: {
                        currency_code: "GBP",
                        value: "100.00",
                    },
                },
            ],
        }),
    });

    return handleResponse(response);
}

export async function capturePayment(orderId: string) {
    const accessToken = await generateAccessToken();
    const url = `${base}/v2/checkout/orders/${orderId}/capture`;
    const response = await axios.post(url, {
        headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
        },
    });

    return handleResponse(response);
}

export async function generateAccessToken() {
    const auth = Buffer.from(PAYPAL_CLIENT_ID + ":" + PAYPAL_SECRET).toString("base64");
    const response = await axios.post(`${base}/v1/oauth2/token`, {
        body: "grant_type=client_credentials",
        headers: {
            Authorization: `Basic ${auth}`,
        },
    });

    const jsonData = await handleResponse(response);
    return jsonData.data.access_token;
}

async function handleResponse(response: AxiosResponse) {
    if (response.status === 200 || response.status === 201) {
        return response;
    }

    const errorMessage = response.statusText;
    throw new Error(errorMessage);
}
