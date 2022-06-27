import * as jose from "jose";
import {JWTPayload, JWTVerifyResult, ProtectedHeaderParameters} from "jose";
import {AUTH_ERROR} from "../../errors/AUTH_ERROR";
import {AUTH_ERROR_ENUM} from "../enums/AUTH_ERROR_ENUM";
import {DateTime} from "luxon";
import {AccessTokenHeaderType, RefreshTokenHeaderType, TokenPayloadType} from "../types/tokenType";
import {findPublicKeyUsingKID} from "./accessLib";
import prisma from "../../db/prisma";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";

export const verifySignAccessToken = async (token: string): Promise<TokenPayloadType & AccessTokenHeaderType> => {
    const jwtVerified = await verifyToken(token, false)
    const payload = <TokenPayloadType>jwtVerified.payload
    const header = jwtVerified.protectedHeader as unknown as AccessTokenHeaderType
    return {
        id: payload.id,
        exp: payload.exp,
        kid: header.kid,
        token_id: header.token_id,
        auth_level: header.auth_level
    }
}
export const verifySignRefreshToken = async (token: string): Promise<TokenPayloadType & RefreshTokenHeaderType> => {
    const jwtVerified = await verifyToken(token, true)
    const payload = <TokenPayloadType>jwtVerified.payload
    const header = jwtVerified.protectedHeader as unknown as RefreshTokenHeaderType
    return {
        id: payload.id,
        exp: payload.exp,
        kid: header.kid,
        token_id: header.token_id,
        auth_level: header.auth_level,
        version: header.version,
    }
}
const verifyToken = async (token: string, destroy: boolean): Promise<JWTVerifyResult> => {
    let jwtPayloadUnsecured: JWTPayload
    let jwtHeaderUnsecured: ProtectedHeaderParameters
    let verifiedJWT: JWTVerifyResult

    try {
        jwtPayloadUnsecured = jose.decodeJwt(token)
        jwtHeaderUnsecured = jose.decodeProtectedHeader(token)
    } catch (e) {
        throw new AUTH_ERROR("Token invalid", AUTH_ERROR_ENUM.TOKEN_INVALID, destroy)
    }

    const {exp} = jwtPayloadUnsecured
    const {kid} = jwtHeaderUnsecured

    if (exp === undefined) {
        throw new AUTH_ERROR("Token forged", AUTH_ERROR_ENUM.TOKEN_FORGED, destroy)
    }
    if (DateTime.now().toSeconds() > DateTime.fromSeconds(exp).toSeconds()) {
        throw new AUTH_ERROR("Token expired", AUTH_ERROR_ENUM.TOKEN_EXPIRED, destroy)
    }
    if (kid === undefined) {
        throw new AUTH_ERROR("Token forged", AUTH_ERROR_ENUM.TOKEN_FORGED, destroy)
    }
    const publicKey = await findPublicKeyUsingKID(kid)
    try {
        verifiedJWT = await jose.jwtVerify(token, publicKey)
    } catch (e: any) {
        if (e.code === "ERR_JWT_EXPIRED") throw new AUTH_ERROR("Token expired", AUTH_ERROR_ENUM.TOKEN_EXPIRED, destroy)
        else throw new AUTH_ERROR("Token forged", AUTH_ERROR_ENUM.TOKEN_FORGED, destroy)
    }
    return verifiedJWT
}


export const verifyExtraPropertyRefreshToken = async (refreshToken: TokenPayloadType & RefreshTokenHeaderType) => {
    const {token_id, version, id} = refreshToken

    const tokenDB = await prisma.refresh_tokens.findUnique({
        where: {
            token_id: token_id as number
        }
    })
    if(tokenDB === null){
        throw new AUTH_ERROR("Token has been destroyed for security reasons", AUTH_ERROR_ENUM.TOKEN_DESTROYED)
    }
    if(tokenDB.user_id !== id){
        await prisma.refresh_tokens.delete({where: {token_id: token_id}})
        throw new AUTH_ERROR("Token is no more valid", AUTH_ERROR_ENUM.TOKEN_INVALID)
    }
    const versionDB = tokenDB.version
    if(version !== versionDB){
        await prisma.refresh_tokens.delete({
            where: {
                token_id: token_id as number
            }
        })
        throw new AUTH_ERROR("Token has been destroyed for security reasons", AUTH_ERROR_ENUM.TOKEN_DESTROYED)
    }
}
export const verifyExtraPropertyAccessToken = async (accessToken: TokenPayloadType & AccessTokenHeaderType, ipReq: string, uaReq: string) => {
    const {token_id, id} = accessToken

    let result
    try{
        result = await prisma.access_token.findUnique({
            where: {
                token_id: token_id
            },
            select: {
                ip: true,
                ua: true,
                refresh_tokens: {
                    select: {
                        user_id: true
                    }
                }
            },
            rejectOnNotFound: true
        })
    }catch (e: any){
        if(e.name === "NotFoundError") throw new AUTH_ERROR("Token has been destroyed for security reasons", AUTH_ERROR_ENUM.TOKEN_DESTROYED, false)
        else throw new INTERNAL_ERROR("DB has encountered an error", INTERNAL_ERROR_ENUM.DB_ERROR)
    }

    if(result.refresh_tokens.user_id !== id){
        await prisma.access_token.delete({where: {token_id: token_id}})
        throw new AUTH_ERROR("Token is no more valid", AUTH_ERROR_ENUM.TOKEN_INVALID)
    }

    const ip = result.ip
    const ua = result.ua

    if(ip !== "Not Found" && ipReq !== ip) {
        await prisma.access_token.delete({where: {token_id: token_id}})
        throw new AUTH_ERROR("IP not corresponding", AUTH_ERROR_ENUM.IP_NOT_CORRESPONDING, false)
    }
    if(ua !== "Not Found" && uaReq !== ua) {
        await prisma.access_token.delete({where: {token_id: token_id}})
        throw new AUTH_ERROR("User Agent not corresponding", AUTH_ERROR_ENUM.UA_NOT_CORRESPONDING, false)
    }
}