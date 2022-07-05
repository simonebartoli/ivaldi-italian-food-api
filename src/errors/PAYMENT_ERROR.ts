import {ApolloError} from "apollo-server-express";
import {PAYMENT_ERROR_ENUM} from "../schema/enums/PAYMENT_ERROR_ENUM";

export class PAYMENT_ERROR extends ApolloError{
    constructor(message: string, code: PAYMENT_ERROR_ENUM) {
        super(message, "PAYMENT_ERROR", {
            type: code,
            status: 400
        });
    }
}