import 'dotenv/config'

export const MIN_ORDER_PRICE = 40

export const ENV = process.env["NODE_ENV"] as "development" | "production"
export const STRIPE_SECRET_KEY = process.env["STRIPE_SECRET_KEY"] as string
export const COOKIE_SECURE = process.env["COOKIE_SECURE"] as string
export const WEBHOOK_SECRET_KEY = process.env["WEBHOOK_SECRET_KEY"] as string

export const PAYPAL_CLIENT_ID = process.env["PAYPAL_CLIENT_ID"] as string
export const PAYPAL_SECRET = process.env["PAYPAL_SECRET"] as string

export const EMAIL_SERVER_HOST = process.env["EMAIL_SERVER_HOST"] as string
export const EMAIL_SERVER_PORT = process.env["EMAIL_SERVER_PORT"] as string
export const EMAIL_SERVER_USER = process.env["EMAIL_SERVER_USER"] as string
export const EMAIL_SERVER_PASSWORD = process.env["EMAIL_SERVER_PASSWORD"] as string

export const PDF_FONTS = {
    Courier: {
        normal: 'Courier',
        bold: 'Courier-Bold',
        italics: 'Courier-Oblique',
        bolditalics: 'Courier-BoldOblique'
    },
    Helvetica: {
        normal: 'Helvetica',
        bold: 'Helvetica-Bold',
        italics: 'Helvetica-Oblique',
        bolditalics: 'Helvetica-BoldOblique'
    },
    Times: {
        normal: 'Times-Roman',
        bold: 'Times-Bold',
        italics: 'Times-Italic',
        bolditalics: 'Times-BoldItalic'
    },
    Symbol: {
        normal: 'Symbol'
    },
    ZapfDingbats: {
        normal: 'ZapfDingbats'
    }
};
