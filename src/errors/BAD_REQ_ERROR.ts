import {ApolloError} from "apollo-server-express";
import {BAD_REQ_ERROR_ENUM} from "../schema/enums/BAD_REQ_ERROR_ENUM";

export class BAD_REQ_ERROR extends ApolloError{
    constructor(message: string, code: BAD_REQ_ERROR_ENUM) {
        super(message, "BAD_REQ_ERROR", {
            type: code,
            status: 400
        });
    }
}