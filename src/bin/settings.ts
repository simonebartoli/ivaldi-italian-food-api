import 'dotenv/config'
export const STRIPE_SECRET_KEY = process.env["STRIPE_SECRET_KEY"] as string
export const COOKIE_SECURE = process.env["COOKIE_SECURE"] as string
export const WEBHOOK_SECRET_KEY = process.env["WEBHOOK_SECRET_KEY"] as string

export const PAYPAL_CLIENT_ID = process.env["PAYPAL_CLIENT_ID"] as string
export const PAYPAL_SECRET = process.env["PAYPAL_SECRET"] as string