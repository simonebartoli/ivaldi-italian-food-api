import axios, {AxiosResponse} from "axios";

import {PAYPAL_CLIENT_ID, PAYPAL_SECRET} from "../../../bin/settings";
import {INTERNAL_ERROR} from "../../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../../enums/INTERNAL_ERROR_ENUM";

const base = "https://api-m.sandbox.paypal.com";

type PurchaseUnitsType = { amount: { currency_code: string, value: string }, shipping: { address: { country_code: string, address_line_1: string, address_line_2: string | null, postal_code: string }, name: { full_name: string }, type: string, invoice_id?: string } }[]
type PayerType = {email_address: string | null, address: {country_code: string, address_line_1: string, address_line_2: string | null, admin_area_1: string, admin_area_2: string, postal_code: string}, birth_date: string, name: {}, phone?: any}

export async function createOrder(purchase_units: PurchaseUnitsType, payer: PayerType) {
    const accessToken = await generateAccessToken();
    const url = `${base}/v2/checkout/orders`;

    const response = await axios.post(url,
        {
            intent: "CAPTURE",
            purchase_units: purchase_units,
            payer: payer
        },
        {
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${accessToken}`,
            }
        }
    );

    return handleResponse(response);
}

export async function updateOrder(order_id: string, invoice_id: string) {
    const accessToken = await generateAccessToken();
    const url = `${base}/v2/checkout/orders/${order_id}`;
    await axios.patch(url,
        [{
            op: "add",
            path: "/purchase_units/@reference_id=='default'/invoice_id",
            value: invoice_id
        }],
        {
            headers: {
                "Content-Type": "application/json",
                Authorization: `Bearer ${accessToken}`,
            },
        }
    );
}

export async function capturePayment(orderId: string) {
    const accessToken = await generateAccessToken();
    const url = `${base}/v2/checkout/orders/${orderId}/capture`;
    const response = await axios.post(url, {},{
        headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${accessToken}`,
        },
    });
    return handleResponse(response);
}

export async function generateAccessToken() {
    const auth = Buffer.from(PAYPAL_CLIENT_ID + ":" + PAYPAL_SECRET).toString("base64");
    const response = await axios.post(`${base}/v1/oauth2/token`, new URLSearchParams({"grant_type": "client_credentials"}),
        {
            headers: {
                Authorization: `Basic ${auth}`,
                "content-type": 'application/x-www-form-urlencoded'
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
    throw new INTERNAL_ERROR(errorMessage, INTERNAL_ERROR_ENUM.PAYMENT_PROVIDER_ERROR);
}
