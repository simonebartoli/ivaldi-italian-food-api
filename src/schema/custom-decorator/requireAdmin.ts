import {createMethodDecorator} from "type-graphql";
import {AUTH_ERROR} from "../../errors/AUTH_ERROR";
import {AUTH_ERROR_ENUM} from "../enums/AUTH_ERROR_ENUM";
import * as jose from "jose";
import {AccessTokenHeaderType} from "../types/not-graphql/tokenType";

export function RequireAdmin() {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const token = req.headers.authorization

        if(token === undefined || !token.includes("Bearer ")){
            throw new AUTH_ERROR("Access Token Missing", AUTH_ERROR_ENUM.TOKEN_INVALID, false)
        }

        const jwtHeaderUnsecured: AccessTokenHeaderType = jose.decodeProtectedHeader(token.split(" ")[1]) as AccessTokenHeaderType
        const role = jwtHeaderUnsecured.role

        if(role !== "admin"){
            throw new AUTH_ERROR("Only Admin Authorized to perform this operation", AUTH_ERROR_ENUM.ADMIN_REQUIRED)
        }
        return next();
    });
}