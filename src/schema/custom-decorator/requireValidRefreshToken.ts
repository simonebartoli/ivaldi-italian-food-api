import {createMethodDecorator} from "type-graphql";
import {BAD_REQ_ERROR} from "../../errors/BAD_REQ_ERROR";
import {BAD_REQ_ERROR_ENUM} from "../enums/BAD_REQ_ERROR_ENUM";
import {verifyExtraPropertyRefreshToken, verifySignRefreshToken} from "../lib/tokenVerificationLib";

export function RequireValidRefreshToken() {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const token = req.cookies.token
        if(token === undefined){
            throw new BAD_REQ_ERROR("User Needs to have a refresh token", BAD_REQ_ERROR_ENUM.REFRESH_TOKEN_MISSING)
        }
        const refreshToken = await verifySignRefreshToken(token)
        await verifyExtraPropertyRefreshToken(refreshToken)

        return next();
    });
}