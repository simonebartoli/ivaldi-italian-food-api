import {ApolloError} from "apollo-server-express";
import {FORMAT_ERROR_ENUM} from "../schema/enums/FORMAT_ERROR_ENUM";

export class FORMAT_ERROR extends ApolloError {
    constructor(message: string, code: FORMAT_ERROR_ENUM, extra?: any) {
        super(message, "FORMAT_ERROR", {
            type: code,
            status: 400,
            info: extra
        });
    }
}