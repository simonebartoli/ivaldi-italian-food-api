import fs from "fs";
import path from "path";
import Handlebars from "handlebars"
import nodemailer from "nodemailer"
import {EMAIL_SERVER_HOST, EMAIL_SERVER_PASSWORD, EMAIL_SERVER_PORT, EMAIL_SERVER_USER, ENV} from "./settings";

const emailToVerifyFile = fs.readFileSync(path.join(process.cwd(), "/emails/email-confirmation.hbs"))
const loginNoPasswordFile = fs.readFileSync(path.join(process.cwd(), "/emails/verification.hbs"))
const orderConfirmationFile = fs.readFileSync(path.join(process.cwd(), "/emails/order-confirmation.hbs"))
const contactFile = fs.readFileSync(path.join(process.cwd(), "/emails/contact.hbs"))

export const emailToVerifyCompiled = Handlebars.compile(emailToVerifyFile.toString())
export const loginNoPasswordCompiled = Handlebars.compile(loginNoPasswordFile.toString())
export const orderConfirmationCompiled = Handlebars.compile(orderConfirmationFile.toString())
export const contactCompiled = Handlebars.compile(contactFile.toString())


export const transporter = async () => {
    if(ENV === "development"){
        const testAccount = await nodemailer.createTestAccount()
        return nodemailer.createTransport({
            host: "smtp.ethereal.email",
            port: 587,
            secure: false, // true for 465, false for other ports
            auth: {
                user: testAccount.user, // generated ethereal user
                pass: testAccount.pass, // generated ethereal password
            },
        })
    }else{
        return nodemailer.createTransport({
            host: EMAIL_SERVER_HOST,
            pool: true,
            port: Number(EMAIL_SERVER_PORT),
            secure: false, // true for 465, false for other ports
            auth: {
                user: EMAIL_SERVER_USER, // generated ethereal user
                pass: EMAIL_SERVER_PASSWORD, // generated ethereal password
            },
            tls: {
                rejectUnauthorized: false
            }
            // ignoreTLS: true
        })
    }
}