import {ApolloError} from "apollo-server-express";
import {DATA_ERROR_ENUM} from "../schema/enums/DATA_ERROR_ENUM";

export class DATA_ERROR extends ApolloError{
    constructor(message: string, code: DATA_ERROR_ENUM) {
        super(message, "DATA_ERROR", {
            type: code,
            status: 400
        });
    }
}