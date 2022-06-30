import {createMethodDecorator} from "type-graphql";
import {AUTH_ERROR} from "../../errors/AUTH_ERROR";
import {AUTH_ERROR_ENUM} from "../enums/AUTH_ERROR_ENUM";
import {verifyExtraPropertyAccessToken, verifySignAccessToken} from "../lib/tokenVerificationLib";

export function RequireValidAccessToken() {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const token = req.headers.authorization
        const ipReq = req.socket.remoteAddress || req.ip
        const uaReq = req.get('User-Agent')

        if(token === undefined || !token.includes("Bearer ")){
            throw new AUTH_ERROR("Access Token Missing", AUTH_ERROR_ENUM.TOKEN_INVALID, false)
        }
        const accessToken = await verifySignAccessToken(token.split(" ")[1])
        await verifyExtraPropertyAccessToken(accessToken, ipReq, uaReq)

        context.user_id = accessToken.id
        return next();
    });
}