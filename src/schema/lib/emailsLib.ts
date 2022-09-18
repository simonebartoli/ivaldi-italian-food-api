import {
    contactCompiled,
    emailToVerifyCompiled,
    loginNoPasswordCompiled,
    orderConfirmationCompiled,
    transporter
} from "../../bin/init-emails";
import path from "path";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";
import {DOMAIN, EMAIL_SERVER_FALLBACK_USER, EMAIL_SERVER_USER, ENV} from "../../bin/settings";
import nodemailer, {SentMessageInfo} from "nodemailer";

type EmailInfoType = {
    [id: string]: string
}

export const createEmail_EmailToVerify = async (emailInfo: EmailInfoType) => {
    const emailToSend = emailToVerifyCompiled({
        name: emailInfo["name"],
        surname: emailInfo["surname"],
        security_code: emailInfo["security_code"],
        token: emailInfo["token"],
        expiry_datetime: emailInfo["expiry_datetime"]
    })
    await sendEmail(emailToSend, "Ivaldi Italian Food - Verify your Email", emailInfo["to"] as string)
}
export const createEmail_LoginNoPassword = async (emailInfo: EmailInfoType) => {
    const emailToSend = loginNoPasswordCompiled({
        name: emailInfo["name"],
        surname: emailInfo["surname"],
        security_code: emailInfo["security_code"],
        token: emailInfo["token"],
        expiry_datetime: emailInfo["expiry_datetime"]
    })
    await sendEmail(emailToSend, "Ivaldi Italian Food - Verify your Access", emailInfo["to"] as string)
}
export const createEmail_OrderConfirmation = async (emailInfo: EmailInfoType) => {
    const emailToSend = orderConfirmationCompiled({
        name: emailInfo["name"],
        surname: emailInfo["surname"],
        datetime: emailInfo["datetime"],
        order_link: `${DOMAIN}/orders?order_ref=${emailInfo["reference"]}`,
        receipt_link: `${DOMAIN}/receipts?order_ref=${emailInfo["reference"]}`
    })
    await sendEmail(emailToSend, "Ivaldi Italian Food - Order Confirmation", emailInfo["to"] as string, true)
}
export const createEmail_Contact = async (emailInfo: EmailInfoType) => {
    const emailToSend = contactCompiled({
        name: emailInfo["name"],
        surname: emailInfo["surname"],
        email: emailInfo["email"],
        phone_number: emailInfo["phone_number"],
        message: emailInfo["message"],
    })
    await sendEmail(emailToSend, "Ivaldi Italian Food - Contact Request", emailInfo["to"] as string, true)
}

const sendEmail = async (emailToSend: string, title: string, to: string, admin_email: boolean = false) => {
    let emailSent: SentMessageInfo
    let SENT = false
    let ATTEMPTS = 0

    do{
        try{
            emailSent = await (await transporter()).sendMail({
                from: `Ivaldi Italian Food <${EMAIL_SERVER_USER}>`,
                to: to,
                subject: title,
                html: emailToSend,
                attachments: [
                    {
                        cid: "logo",
                        path: path.join(process.cwd(), "/images/logo.png")
                    }
                ]
            })
            if(admin_email){
                await (await transporter()).sendMail({
                    from: `Ivaldi Italian Food <${EMAIL_SERVER_USER}>`,
                    to: EMAIL_SERVER_FALLBACK_USER,
                    subject: title,
                    html: emailToSend,
                    attachments: [
                        {
                            cid: "logo",
                            path: path.join(process.cwd(), "/images/logo.png")
                        }
                    ]
                })
            }
            SENT = true

        }catch (e) {
            console.log((e as Error))
        }
        finally {
            ATTEMPTS += 1
        }
    }while (!SENT && ATTEMPTS < 3)

    if(!SENT) throw new INTERNAL_ERROR("The email has not been sent", INTERNAL_ERROR_ENUM.EMAIL_ERROR)
    if(ENV === "development") console.log(nodemailer.getTestMessageUrl(emailSent))
}