import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {Context} from "../types/not-graphql/contextType";
import fs from "fs";
import {CreateRetrievePdfInput} from "../inputs/createRetrievePdfInput";
import {retrieveOrderInfo} from "../lib/receiptsLib";
import hash from "object-hash";
import {DateTime} from "luxon";
import {RefundType} from "../lib/refundsLib";
import {DOMAIN} from "../../bin/settings";

const notices = [
    {
        text: "Notices",
        fontSize: 20,
        alignment: "center",
        margin: [0, 0, 0, 20],
        pageBreak: "before"
    },
    {
        text: "This DOCUMENT has been created on the date shown on the header/footer. The state of the document could change in the future but IVALDI ITALIAN FOOD confirms that the information written in this document, until the date reported, are correct and verified.",
        lineHeight: 2,
        alignment: "justify",
        margin: [0, 0, 0, 20]
    },
    {
        text: "To get the current updated document please scan the QR Code below or open the link here attached.",
        alignment: "justify",
        lineHeight: 2,
        margin: [0, 0, 0, 20]
    }
]

@Resolver()
export class PdfResolvers{
    qrCode(order_ref: string){
        return [
            {
                qr: `${DOMAIN}/get-receipt?order_ref=${order_ref}`,
                alignment: "center",
                margin: [0, 0, 0, 10]
            },
            {
                text: `${DOMAIN}/get-receipt?order_ref=${order_ref}`,
                alignment: "center",
                link: `${DOMAIN}/get-receipt?order_ref=${order_ref}`
            }
        ]
    }
    finalStatement(total: number, vat_total: number, refund_total: number, shipping_cost: number, shipping_cost_refunded: boolean) {
        return [
            {
                columns: [
                    {
                        text: "Total (No Vat | No Shipping): ",
                        fontSize: 20,
                        width: "*",
                        alignment: "right"
                    },
                    {
                        text: `£ ${(total - vat_total - shipping_cost).toFixed(2)}`,
                        fontSize: 20,
                        width: "20%",
                        alignment: "right"
                    }
                ],
                margin: [0, 10],
                columnGap: 10
            },
            {
                columns: [
                    {
                        text: "VAT: ",
                        fontSize: 20,
                        width: "*",
                        alignment: "right"
                    },
                    {
                        text: `£ ${vat_total.toFixed(2)}`,
                        fontSize: 20,
                        width: "20%",
                        alignment: "right"
                    }
                ],
                margin: [0, 10],
                columnGap: 10
            },
            {
                columns: [
                    {
                        text: `Shipping Cost${shipping_cost_refunded ? " (REFUNDED)" : ""}: `,
                        fontSize: 20,
                        width: "*",
                        alignment: "right"
                    },
                    {
                        text: `£ ${shipping_cost.toFixed(2)}`,
                        fontSize: 20,
                        width: "20%",
                        alignment: "right"
                    }
                ],
                margin: [0, 10],
                columnGap: 10
            },
            {
                columns: [
                    {
                        text: "Refunds: ",
                        fontSize: 20,
                        width: "*",
                        alignment: "right"
                    },
                    {
                        text: `£ ${refund_total.toFixed(2)}`,
                        fontSize: 20,
                        width: "20%",
                        alignment: "right"
                    }
                ],
                margin: [0, 10],
                columnGap: 10
            },
        ]
    }
    mainTable(formattedBody: ({text: string, margin: number[], fontSize?: undefined, alignment?: undefined} | {text: number, margin: number[], fontSize?: undefined, alignment?: undefined} | {text: string, margin: number[], fontSize: number, alignment: string})[][]) {
        return [
            {
                layout: 'lightHorizontalLines',
                table: {
                    headerRows: 1,
                    widths: ["*", "auto", "auto", "auto", "25%"],
                    body: [
                        ["Name", "Price Unit", "Quantity", "Vat %", {text: "Price Total", alignment: "right"}],
                        ...formattedBody
                    ]
                },
                margin: [0, 20, 0, 20]
            },

        ]
    }
    mainInfo(datetime: Date, user: {name: string, surname: string}, formattedAddress: string, payment_method: {type: "CARD" | "PAYPAL", account: string}) {
        return [
            {
                columns: [
                    {
                        text: "Purchase Date: ",
                        fontSize: 15,
                        width: "30%"
                    },
                    {
                        text: DateTime.fromJSDate(datetime).toLocaleString(DateTime.DATETIME_SHORT),
                        fontSize: 15,
                        width: "auto"
                    }
                ],
                margin: [0, 10],
                columnGap: 10
            },
            {
                columns: [
                    {
                        text: "Billed To: ",
                        fontSize: 15,
                        width: "30%"
                    },
                    {
                        text: `${user.name} ${user.surname}, ${formattedAddress}`,
                        fontSize: 15,
                        width: "auto"
                    }
                ],
                margin: [0, 10],
                columnGap: 10
            },
            {
                columns: [
                    {
                        text: "Payment Method: ",
                        fontSize: 15,
                        width: "30%"
                    },
                    {
                        text: `${payment_method.type} (${payment_method.type === "CARD" ? "ending " + payment_method.account : payment_method.account})`,
                        fontSize: 15,
                        width: "auto"
                    }
                ],
                margin: [0, 10],
                columnGap: 10
            },
        ]
    }
    total(invoiceNumber: number, order_ref: string, total: number) {
        return [
            {
                columns: [
                    {
                        stack: [
                            {
                                text: `INVOICE N.${(invoiceNumber.toString()).padStart(9, "0")}`,
                                bold: true,
                                fontSize: 25,
                            },
                            {
                                text: `ORDER REF ${order_ref.toUpperCase()}`,
                                fontSize: 11,
                            }
                        ],
                        margin: [0,4,0,4],
                        lineHeight: 2,
                        width: "*"
                    },
                    {
                        stack: [
                            {
                                text: "Ivaldi Italian Food",
                                color: "#16a34a",
                                fontSize: 18,
                                bold: true,
                            },
                            {
                                text: "More Info at ivaldi.uk",
                                fontSize: 12,
                            },
                            {
                                text: "Support at info@ivaldi.uk",
                                fontSize: 12,
                            }
                        ],
                        lineHeight: 2,
                        width: "auto"
                    }
                ],
            },
            {
                columns: [
                    {
                        text: "TOTAL: ",
                        bold: true,
                        fontSize: 25,
                        width: "auto"
                    },
                    {
                        text: `£ ${total.toFixed(2)}`,
                        bold: true,
                        fontSize: 25,
                        width: "auto"
                    }
                ],
                margin: [0, 35, 0, 10],
                columnGap: 10
            }
        ]
    }
    refundTable(refunds: RefundType[] | null) {
        if(refunds === null) return []
        const result: any[] = []
        result.push(
            {
                text: "Refunded Items",
                alignment: "center",
                fontSize: 18,
                margin: [0, 0, 0, 30],
                pageBreak: "before"
            }
        )

        for(const refund of refunds){
            const date = DateTime.fromJSDate(refund.datetime).toLocaleString(DateTime.DATETIME_SHORT)
            let total = 0
            for(const item of refund.items_refunded){
                total += item.price_total
            }
            const notes = refund.notes

            const bodyTable: any[] = []
            for(const item of refund.items_refunded){
                bodyTable.push([
                    {
                        text: item.name,
                        margin: [0, 7]
                    },
                    {
                        text: `£ ${item.price_per_unit.toFixed(2)}`,
                        margin: [0, 7]
                    },
                    {
                        text: item.amount_refunded,
                        margin: [0, 7]
                    },
                    {
                        text: `£ ${item.taxes.toFixed(2)}`,
                        margin: [0, 7]
                    },
                    {
                        text: `£ ${item.price_total.toFixed(2)}`,
                        margin: [0, 5],
                        fontSize: 15,
                        alignment: "right"
                    }
                ])
            }

            result.push(
                {
                    columns: [
                        {
                            text: "Date: ",
                            fontSize: 12,
                            width: "30%"
                        },
                        {
                            text: date,
                            fontSize: 12,
                            width: "*"
                        }
                    ],
                    margin: [0, 20, 0, 4]
                },
                {
                    columns: [
                        {
                            text: "Notes:",
                            fontSize: 12,
                            width: "30%"
                        },
                        {
                            text: notes,
                            fontSize: 12,
                            width: "*"
                        }
                    ],
                    margin: [0, 8, 0, 4]
                },
                {
                    columns: [
                        {
                            text: "Total:",
                            fontSize: 12,
                            width: "30%"
                        },
                        {
                            text: `£ ${total.toFixed(2)}`,
                            fontSize: 12,
                            width: "*"
                        }
                    ],
                    margin: [0, 8, 0, 6]
                },
                {
                    layout: 'lightHorizontalLines',
                    table: {
                        headerRows: 1,
                        widths: ["*", "auto", "auto", "auto", "25%"],
                        body: [
                            ["Name", "Price Unit", "Quantity", "Taxes", {text: "Refunded Total", alignment: "right"}],
                            ...bodyTable
                        ]
                    },
                    margin: [0, 20, 0, 20]
                }
            )
        }
        return result
    }

    @Mutation(returns => String)
    async getOrCreateReceiptPDF (@Ctx() ctx: Context, @Arg("data") inputData: CreateRetrievePdfInput) {
        const {order_ref} = inputData
        const result = await retrieveOrderInfo(order_ref)
        const resultHashed = hash(result)
        console.log(resultHashed)

        if(fs.existsSync(process.cwd() + "/receipts-pdf/" + resultHashed)) return resultHashed
        const {billingAddress, refunds, items, datetime, invoiceNumber, user, total, vat_total, shipping_cost, payment_method, shipping_cost_refunded} = result
        const formattedAddress = billingAddress.first_address + ", " +
                                    (billingAddress.second_address ? billingAddress.second_address + ", " : "") +
                                    billingAddress.postcode + ", " +
                                    billingAddress.city + ", " +
                                    billingAddress.country
        const formattedBody = items.map((element) => {
            return [
                {
                    text: element.name,
                    margin: [0, 7]
                },
                {
                    text: "£ " + element.price_per_unit.toFixed(2),
                    margin: [0, 7]
                },
                {
                    text: element.amount,
                    margin: [0, 7]
                },
                {
                    text: element.vat + "%",
                    margin: [0, 7]
                },
                {
                    text: "£ " + element.price_total.toFixed(2),
                    margin: [0, 5],
                    fontSize: 15,
                    alignment: "right"
                }
            ]
        })
        let refund_total = 0
        if(refunds){
            for(const refund of refunds){
                for(const item of refund.items_refunded){
                    refund_total += item.price_total
                }
            }
        }

        if(shipping_cost_refunded) refund_total += shipping_cost

        const docDefinition = {
            pageMargins: [ 40, 60, 40, 60 ],
            info: {
                title: "Invoice N." + (invoiceNumber.toString()).padStart(9, "0"),
                author: 'Ivaldi Italian Food',
                subject: 'Invoice PDF',
                producer: "Ivaldi Italian Food"
            },
            header: [
                {
                    columns: [
                        {
                            text: `${user.name} ${user.surname} - Invoice N.${(invoiceNumber.toString()).padStart(9, "0")}`,
                            width: "*"
                        },
                        {
                            text: `Created At ${DateTime.fromJSDate(datetime).toLocaleString(DateTime.DATETIME_SHORT)}`,
                            alignment: "right",
                            bold: true,
                            width: "*"
                        }
                    ],
                    margin: [40, 15]
                }
            ],
            footer: (currentPage: number) => {
                return [
                    {
                        text: currentPage.toString(),
                        alignment: "center"
                    }
                ]
            },
            content: [
                ...this.total(invoiceNumber, order_ref, total),
                ...this.mainInfo(datetime, user, formattedAddress, payment_method),
                ...this.mainTable(formattedBody),
                ...this.finalStatement(total, vat_total, refund_total, shipping_cost, shipping_cost_refunded),
                ...this.refundTable(refunds),
                ...notices,
                ...this.qrCode(order_ref)
            ],
            defaultStyle: {
                font: 'Times'
            }
        };
        console.log("PASS HERE")

        // @ts-ignore
        const pdfDoc = ctx.PdfGenerator.createPdfKitDocument(docDefinition);

        fs.mkdirSync(process.cwd() + `/receipts-pdf/${resultHashed}`)
        pdfDoc.pipe(fs.createWriteStream(process.cwd() + `/receipts-pdf/${resultHashed}/invoice.pdf`));
        pdfDoc.end();
        return resultHashed
    }

}