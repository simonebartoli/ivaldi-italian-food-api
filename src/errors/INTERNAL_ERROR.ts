import {ApolloError} from "apollo-server-express";
import {INTERNAL_ERROR_ENUM} from "../schema/enums/INTERNAL_ERROR_ENUM";

export class INTERNAL_ERROR extends ApolloError{
    constructor(message: string, code: INTERNAL_ERROR_ENUM) {
        super(message, "INTERNAL_ERROR", {
            type: code,
            status: 400
        });
    }
}