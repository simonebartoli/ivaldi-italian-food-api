import {ApolloError} from "apollo-server-express";
import {AUTH_ERROR_ENUM} from "../schema/enums/AUTH_ERROR_ENUM";

export class AUTH_ERROR extends ApolloError{
    constructor(message: string, code: AUTH_ERROR_ENUM, destroyCookie: boolean = true) {
        super(message, "AUTH_ERROR", {
            type: code,
            status: 400,
            destroy: destroyCookie
        });
    }
}