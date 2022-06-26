import {createMethodDecorator} from "type-graphql";
import {BAD_REQ_ERROR} from "../../errors/BAD_REQ_ERROR";
import {BAD_REQ_ERROR_ENUM} from "../enums/BAD_REQ_ERROR_ENUM";
import {PublicKeyType} from "../types/keyType";
import fs from "fs";
import * as jose from "jose";
import {AUTH_ERROR} from "../../errors/AUTH_ERROR";
import {AUTH_ERROR_ENUM} from "../enums/AUTH_ERROR_ENUM";
import {DateTime} from "luxon";
import {JWTVerifyResult, KeyLike} from "jose";
import prisma from "../../db/prisma";

export function RequireValidRefreshToken() {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const tokenCookie = req.cookies.token
        if(tokenCookie === undefined){
            throw new BAD_REQ_ERROR("User Needs to have a refresh token", BAD_REQ_ERROR_ENUM.REFRESH_TOKEN_MISSING)
        }

        const publicKeys: PublicKeyType[] = JSON.parse(fs.readFileSync(process.cwd() + "/keys/public-keys.json").toString())
        const token = req.cookies.token

        let jwtPayloadUnsecured: any
        let jwtHeaderUnsecured: any
        let verifiedJWT: any

        try{
            jwtPayloadUnsecured = jose.decodeJwt(token)
            jwtHeaderUnsecured = jose.decodeProtectedHeader(token)
        }catch (e){
            throw new AUTH_ERROR("Token invalid", AUTH_ERROR_ENUM.TOKEN_INVALID)
        }

        const {exp} = jwtPayloadUnsecured
        const {kid} = jwtHeaderUnsecured

        if(exp === undefined){
            throw new AUTH_ERROR("Token forged", AUTH_ERROR_ENUM.TOKEN_FORGED)
        }
        if(DateTime.now().toSeconds() > DateTime.fromSeconds(exp).toSeconds()){
            throw new AUTH_ERROR("Token expired", AUTH_ERROR_ENUM.TOKEN_EXPIRED)
        }
        if(kid === undefined){
            throw new AUTH_ERROR("Token forged", AUTH_ERROR_ENUM.TOKEN_FORGED)
        }


        const indexPublicKey = publicKeys.findIndex((element) => element.kid === kid)
        if(indexPublicKey === -1){
            throw new AUTH_ERROR("Token forged", AUTH_ERROR_ENUM.TOKEN_FORGED)
        }
        const publicKey = <KeyLike> await jose.importJWK(publicKeys[indexPublicKey]!.content, "RS256")

        try{
            verifiedJWT = <JWTVerifyResult> await jose.jwtVerify(token, publicKey)
        }catch (e: any){
            if(e.code === "ERR_JWT_EXPIRED") throw new AUTH_ERROR("Token expired", AUTH_ERROR_ENUM.TOKEN_EXPIRED)
            else throw new AUTH_ERROR("Token forged", AUTH_ERROR_ENUM.TOKEN_FORGED)
        }

        const {token_id, version, level_auth} = verifiedJWT.protectedHeader
        const {user_id} = verifiedJWT.payload

        const tokenDB = await prisma.refresh_tokens.findFirst({
            where: {
                token_id: token_id
            }
        })
        if(tokenDB === null){
            throw new AUTH_ERROR("Token has been destroyed for security reasons", AUTH_ERROR_ENUM.TOKEN_DESTROYED)
        }

        const versionDB = tokenDB.version
        if(version !== versionDB){
            await prisma.refresh_tokens.delete({
                where: {
                    token_id: token_id
                }
            })
            await prisma.access_token.deleteMany({
                where: {
                    refresh_token_id: token_id
                }
            })
            throw new AUTH_ERROR("Token has been destroyed for security reasons", AUTH_ERROR_ENUM.TOKEN_DESTROYED)
        }

        return next();
    });
}