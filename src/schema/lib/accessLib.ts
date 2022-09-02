import {KeyObject, PrivateKeyType, PublicKeyType} from "../types/not-graphql/keyType";
import fs from "fs";
import {DateTime} from "luxon";
import * as jose from "jose";
import {KeyLike} from "jose";
import {INTERNAL_ERROR} from "../../errors/INTERNAL_ERROR";
import {INTERNAL_ERROR_ENUM} from "../enums/INTERNAL_ERROR_ENUM";
import {Buffer} from "buffer";
import {Context} from "../types/not-graphql/contextType";
import prisma from "../../db/prisma";
import {AUTH_ERROR} from "../../errors/AUTH_ERROR";
import {AUTH_ERROR_ENUM} from "../enums/AUTH_ERROR_ENUM";
import {COOKIE_SECURE} from "../../bin/settings";

export const findPrivateKey = async (): Promise<KeyObject> => {
    let privateKeysFile: string = fs.readFileSync(process.cwd() + "/keys/private-keys.json").toString()
    const privateKeys: PrivateKeyType[] = JSON.parse(privateKeysFile)

    for(const privateKey of privateKeys) {
        const retired = privateKey.retired
        if (DateTime.now() < DateTime.fromSeconds(retired)) {
            const kid = privateKey.kid
            const selectedPrivateKey = <KeyLike>await jose.importJWK(privateKey.content, "EdDSA")
            return {
                kid: kid,
                key: selectedPrivateKey
            }
        }
    }
    throw new INTERNAL_ERROR("No valid private keys", INTERNAL_ERROR_ENUM.KEYS_MISSING)
}

export const findPublicKeyUsingKID_base64 = async (kid: string) : Promise<string> => {
    let publicKeysFile: string = fs.readFileSync(process.cwd() + "/keys/public-keys.json").toString()
    const publicKeys: PublicKeyType[] = JSON.parse(publicKeysFile)
    const publicKey = publicKeys.find((element) => element.kid === kid)
    if(publicKey === undefined) throw new INTERNAL_ERROR("No valid public keys", INTERNAL_ERROR_ENUM.KEYS_MISSING)

    const publicKeyFormatted = <KeyLike> await jose.importJWK(publicKey.content, "EdDSA")

    return Buffer
        .from(await jose.exportSPKI(publicKeyFormatted), "utf-8")
        .toString("base64")
}
export const findPublicKeyUsingKID = async (kid: string) : Promise<KeyLike> => {
    let publicKeysFile: string = fs.readFileSync(process.cwd() + "/keys/public-keys.json").toString()
    const publicKeys: PublicKeyType[] = JSON.parse(publicKeysFile)
    const publicKey = publicKeys.find((element) => element.kid === kid)
    if(publicKey === undefined) throw new AUTH_ERROR("No valid kid", AUTH_ERROR_ENUM.TOKEN_FORGED)

    return <KeyLike> await jose.importJWK(publicKey.content, "EdDSA")
}

export const createRefreshToken = async (id: number, auth_level: string, context: Context) => {
    const {res} = context
    const expiryDate = DateTime.now().plus({day: 7}).toSeconds()
    const {kid, key} = await findPrivateKey()

    let refreshTokenID: number
    try{
        const refreshTokenDB = await prisma.refresh_tokens.create({
            data: {
                user_id: id,
                auth_level: auth_level
            }
        })
        refreshTokenID = refreshTokenDB.token_id
    }catch (e){
        throw new INTERNAL_ERROR("DB has encountered an error", INTERNAL_ERROR_ENUM.DB_ERROR)
    }


    const refreshToken = await new jose.SignJWT({
        id: id
    })
        .setExpirationTime(expiryDate)
        .setProtectedHeader({
            kid: kid,
            auth_level: auth_level,
            version: 1,
            token_id: refreshTokenID,
            alg: "EdDSA"
        })
        .sign(key)

    res.cookie("token", refreshToken, {
        expires: DateTime.fromSeconds(expiryDate).toJSDate(),
        secure: COOKIE_SECURE === "true",
        httpOnly: true,
        sameSite: "none"
    })
}
export const updateRefreshToken = async (userID: number, exp: number, authLevel: string, refreshTokenID: number, version: number, ctx: Context) =>{
    const {res} = ctx
    const {kid, key} = await findPrivateKey()

    try{
        await prisma.refresh_tokens.update({
            where: {
                token_id: refreshTokenID
            },
            data: {
                version: version
            }
        })
    }catch (e){
        throw new INTERNAL_ERROR("DB has encountered an error", INTERNAL_ERROR_ENUM.DB_ERROR)
    }

    const refreshToken = await new jose.SignJWT({
        id: userID
    })
        .setExpirationTime(exp)
        .setProtectedHeader({
            kid: kid,
            auth_level: authLevel,
            version: version,
            token_id: refreshTokenID,
            alg: "EdDSA"
        })
        .sign(key)

    res.cookie("token", refreshToken, {
        expires: DateTime.fromSeconds(exp).toJSDate(),
        secure: COOKIE_SECURE === "true",
        sameSite: "none",
        httpOnly: true
    })
}


export const createRecoverToken = async (user_id: number, email_to_verify: boolean, ctx: Context) => {
    const {res} = ctx
    const token = makeRandomToken(64)
    const urlToClick = `http://localhost:3000/verify?secret=${token}`
    const exp = DateTime.now().plus({hour: 1})
    const result = await prisma.recover_tokens.create({
        data: {
            secret: token,
            user_id: user_id,
            expiry: exp.toISO()
        }
    })
    const {token_id} = result
    const {kid, key} = await findPrivateKey()
    const recoverToken = await new jose.SignJWT({
        id: user_id,
        email_to_verify: email_to_verify
    })
        .setExpirationTime(exp.toSeconds())
        .setProtectedHeader({
            kid: kid,
            token_id: token_id,
            alg: "EdDSA"
        })
        .sign(key)
    res.cookie("recover_token", recoverToken, {
        expires: exp.toJSDate(),
        secure: COOKIE_SECURE === "true",
        sameSite: "none",
        httpOnly: true
    })
    return urlToClick
}

export const checkPublicPrivateKeys = async () => {
    try{
        const privateKeys = JSON.parse(fs.readFileSync(process.cwd() + "/keys/private-keys.json", {encoding: "utf-8"}))
        const publicKeys = JSON.parse(fs.readFileSync(process.cwd() + "/keys/public-keys.json", {encoding: "utf-8"}))
        const time = DateTime.now()

        const finalPrivateKeys = []
        const finalPublicKeys = []


        for(const key of privateKeys){
            if(DateTime.fromSeconds(key.expired) > time) {
                finalPrivateKeys.push(key)
            }
        }
        for(const key of publicKeys){
            if(DateTime.fromSeconds(key.expired) > time) {
                finalPublicKeys.push(key)
            }
        }

        return {
            privateKeys: finalPrivateKeys,
            publicKeys: finalPublicKeys
        }
    }catch (e) {
        return {
            privateKeys: [],
            publicKeys: []
        }
    }
}
export const createPublicPrivateKeys = async () => {
    console.log("HERE")

    const {privateKeys, publicKeys} = await checkPublicPrivateKeys()

    const { publicKey, privateKey } = await jose.generateKeyPair('EdDSA')
    let privateJwk = await jose.exportJWK(privateKey)
    let publicJwk = await jose.exportJWK(publicKey)
    const kid = makeRandomToken(16)

    const publicJSON = [{
        kid: kid,
        expired: DateTime.now().plus({day: 14, minute: 5}).toSeconds(),
        content: publicJwk
    }]

    const privateJSON = [{
        kid: kid,
        retired: DateTime.now().plus({day: 7, minute: 5}).toSeconds(),
        expired: DateTime.now().plus({day: 14, minute: 5}).toSeconds(),
        content: privateJwk
    }]

    fs.writeFileSync(process.cwd() + "/keys/private-keys.json", JSON.stringify([...privateJSON, ...privateKeys]))
    fs.writeFileSync(process.cwd() + "/keys/public-keys.json", JSON.stringify([...publicJSON, ...publicKeys]))
}

export const makeRandomToken = (length: number) => {
    let result           = '';
    const characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    const charactersLength = characters.length;
    for (let i = 0; i < length; i++ ) {
        result += characters.charAt(Math.floor(Math.random() *
            charactersLength));
    }
    return result;
}
