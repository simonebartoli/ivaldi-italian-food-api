import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {AccessType} from "../types/accessType";
import {LoginWithPasswordInputs} from "../inputs/loginWithPasswordInputs";
import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import bcrypt from "bcrypt";
import {Context} from "../types/not-graphql/contextType";
import {DateTime} from "luxon";
import * as jose from 'jose'
import * as fs from "fs";
import {RequireNotLogged} from "../custom-decorator/requireNotLogged";
import {RequireValidRefreshToken} from "../custom-decorator/requireValidRefreshToken";
import {RefreshTokenHeaderType, TokenPayloadType} from "../types/not-graphql/tokenType";
import {
    createRecoverToken,
    createRefreshToken,
    findPrivateKey,
    findPublicKeyUsingKID_base64,
    makeRandomToken,
    updateRefreshToken
} from "../lib/accessLib";
import {LoginWithoutPasswordInputs} from "../inputs/loginWithoutPasswordInputs";
import {RequireValidRecoverToken} from "../custom-decorator/requireValidRecoverToken";
import {ChangeRecoverTokenStatusInputs} from "../inputs/changeRecoverTokenStatusInputs";
import {AUTH_ERROR} from "../../errors/AUTH_ERROR";
import {AUTH_ERROR_ENUM} from "../enums/AUTH_ERROR_ENUM";

@Resolver()
export class AccessResolvers {

    @Mutation(returns => Boolean)
    @RequireNotLogged()
    async loginWithPassword(@Arg("credentials") credentials: LoginWithPasswordInputs, @Ctx() ctx: Context): Promise<boolean> {
        const {email, password} = credentials
        const user = await prisma.users.findFirst({
            where: {
                OR: [
                    {
                        email: email.toLowerCase(),
                    },
                    {
                        email_to_verify: email.toLowerCase()
                    }
                ]
            }
        })
        if(user === null){
            throw new DATA_ERROR("Credentials are invalid", DATA_ERROR_ENUM.INVALID_CREDENTIALS)
        }
        if(!bcrypt.compareSync(password, user.password)){
            throw new DATA_ERROR("Credentials are invalid", DATA_ERROR_ENUM.INVALID_CREDENTIALS)
        }
        if(user.email === null){
            const {user_id, email_to_verify} = user
            await createRecoverToken(user_id, email_to_verify !== null, ctx)
            throw new DATA_ERROR("Email Not Verified", DATA_ERROR_ENUM.EMAIL_NOT_VERIFIED)
        }
        await createRefreshToken(user.user_id, "standard", ctx)
        return true
    }

    @Mutation(returns => Boolean)
    @RequireNotLogged()
    async loginWithoutPassword(@Arg("credentials") credentials: LoginWithoutPasswordInputs, @Ctx() ctx: Context): Promise<boolean> {
        const {email} = credentials
        const result = await prisma.users.findFirst({
            where: {
                OR: [
                    {
                        email: email
                    },
                    {
                        email_to_verify: email
                    }
                ]
            }
        })
        if(result === null){
            throw new DATA_ERROR("Email Not Existing", DATA_ERROR_ENUM.INVALID_CREDENTIALS)
        }
        const {user_id, email_to_verify} = result
        await createRecoverToken(result.user_id, email_to_verify !== null, ctx)

        return true
    }

    @Mutation(returns => Boolean)
    @RequireNotLogged()
    @RequireValidRecoverToken()
    async checkRecoverTokenStatus(@Ctx() ctx: Context){
        const {user_id} = ctx
        await createRefreshToken(user_id!, "standard", ctx)
        return true
    }

    @Mutation(returns => Boolean)
    @RequireNotLogged()
    async changeStatusRecoverToken(@Arg("secret") {secret}: ChangeRecoverTokenStatusInputs, @Ctx() ctx: Context){
        try{
            await prisma.recover_tokens.update({
                where: {
                    secret: secret
                },
                data: {
                    status: "AUTHORIZED"
                }
            })
        }catch (e){
            throw new AUTH_ERROR("Token not found", AUTH_ERROR_ENUM.SECRET_INVALID)
        }
        return true
    }

    @Mutation(returns => AccessType)
    @RequireValidRefreshToken()
    async createAccessTokenStandard(@Ctx() ctx: Context): Promise<AccessType>{
        const {req} = ctx
        const token = req.cookies.token
        const refreshTokenPayload = <TokenPayloadType> jose.decodeJwt(token)
        const refreshTokenHeader = <RefreshTokenHeaderType> jose.decodeProtectedHeader(token)

        const accessTokenExp = DateTime.now().plus({minute: 15}).toSeconds()
        const ip = req.socket.remoteAddress || req.ip
        const ua = req.get('User-Agent')

        const userID = refreshTokenPayload.id
        const authLevel = refreshTokenHeader.auth_level
        const refreshTokenVersion = refreshTokenHeader.version
        const refreshTokenExp = refreshTokenPayload.exp
        const refreshTokenID = refreshTokenHeader.token_id

        await updateRefreshToken(
            userID,
            refreshTokenExp,
            authLevel,
            refreshTokenID,
            refreshTokenVersion + 1,
            ctx
        )

        const {kid, key} = await findPrivateKey()
        const publicKey = await findPublicKeyUsingKID_base64(kid)

        const accessTokenDB = await prisma.access_token.create({
            data: {
                ip: ip !== undefined ? ip : "Not Found",
                ua: ua !== undefined ? ua : "Not Found",
                refresh_token_id: refreshTokenHeader.token_id
            }
        })

        const accessTokenID = accessTokenDB.token_id
        const accessTokenJWT = await new jose.SignJWT({
            id: userID
        })
            .setExpirationTime(accessTokenExp)
            .setProtectedHeader({
                kid: kid,
                auth_level: authLevel,
                token_id: accessTokenID,
                alg: "EdDSA"
            })
            .sign(key)

        return {
            accessToken: accessTokenJWT,
            publicKey: publicKey
        }
    }




    // @Mutation(returns => Boolean)
    async createPublicPrivateKeys(): Promise<boolean>{
        const { publicKey, privateKey } = await jose.generateKeyPair('EdDSA')
        let privateJwk = await jose.exportJWK(privateKey)
        let publicJwk = await jose.exportJWK(publicKey)
        const kid = makeRandomToken(16)

        const publicJSON = [{
            kid: kid,
            expired: DateTime.now().plus({day: 14}).toSeconds(),
            content: publicJwk
        }]

        const privateJSON = [{
            kid: kid,
            retired: DateTime.now().plus({day: 7}).toSeconds(),
            expired: DateTime.now().plus({day: 14}).toSeconds(),
            content: privateJwk
        }]

        fs.writeFileSync(process.cwd() + "/keys/private-keys.json", JSON.stringify(privateJSON))
        fs.writeFileSync(process.cwd() + "/keys/public-keys.json", JSON.stringify(publicJSON))

        return true
    }

}