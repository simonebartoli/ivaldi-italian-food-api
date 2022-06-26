import {createMethodDecorator} from "type-graphql";
import {BAD_REQ_ERROR} from "../../errors/BAD_REQ_ERROR";
import {BAD_REQ_ERROR_ENUM} from "../enums/BAD_REQ_ERROR_ENUM";

export function RequireNotLogged() {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const tokenCookie = req.cookies.token
        if(tokenCookie !== undefined){
            throw new BAD_REQ_ERROR("User already logged", BAD_REQ_ERROR_ENUM.ALREADY_LOGGED)
        }
        return next();
    });
}
