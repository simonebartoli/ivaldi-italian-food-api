import {Arg, Ctx, Mutation, Query, Resolver} from "type-graphql";
import {AccessType} from "../types/accessType";
import {LoginWithPasswordInputs} from "../inputs/loginWithPasswordInputs";
import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import bcrypt from "bcrypt";
import {Context} from "../types/not-graphql/contextType";
import {DateTime} from "luxon";
import * as jose from 'jose'
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
import {createEmail_LoginNoPassword} from "../lib/emailsLib";

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
            throw new DATA_ERROR("Email Not Verified",
                DATA_ERROR_ENUM.EMAIL_NOT_VERIFIED,
                {sixDigitCode: makeRandomToken(6)})
        }
        await createRefreshToken(user.user_id, "standard", ctx)
        return true
    }

    @Mutation(returns => String)
    @RequireNotLogged()
    async loginWithoutPassword(@Arg("data") credentials: LoginWithoutPasswordInputs, @Ctx() ctx: Context): Promise<string> {
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
        const {email_to_verify, name, surname} = result
        const token = await createRecoverToken(result.user_id, email_to_verify !== null, ctx)
        const security_code = makeRandomToken(6)

        await createEmail_LoginNoPassword({
            to: email_to_verify || email,
            name: name,
            surname: surname,
            security_code: security_code.toUpperCase(),
            token: token,
            expiry_datetime: DateTime.now().plus({hour: 1}).toLocaleString(DateTime.DATETIME_SHORT)
        })

        return security_code
    }


    @Mutation(returns => Boolean)
    logout(@Ctx() ctx: Context): boolean {
        ctx.res.clearCookie("token")
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
    async changeStatusRecoverToken(@Arg("data") {secret}: ChangeRecoverTokenStatusInputs, @Ctx() ctx: Context){
        const now = DateTime.now().toJSDate()
        try{
            const result = await prisma.recover_tokens.findFirstOrThrow({
                where: {
                    secret: secret,
                    expiry: {
                        gt: now
                    }
                }
            })
            await prisma.recover_tokens.update({
                where: {
                    token_id: result.token_id
                },
                data: {
                    status: "AUTHORIZED"
                }
            })
        }catch (e){
            throw new AUTH_ERROR("Token not found", AUTH_ERROR_ENUM.SECRET_INVALID, false)
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

        const accessTokenExp = DateTime.now().plus({seconds: 5}).toSeconds() //CHANGE HERE
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

        await prisma.access_token.deleteMany({
            where: {
                refresh_token_id: refreshTokenHeader.token_id
            }
        })

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

    @Query(returns => Boolean)
    async checkExistingEmail(@Arg("email") email: string): Promise<boolean> {
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
        if(result !== null){
            if(result.email !== null)
                throw new DATA_ERROR("Email Already Used", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)
            else{
                const entryDate = DateTime.fromJSDate(result.entry_date)
                const entryDatePlusHour = entryDate.plus({hour: 1})
                if(DateTime.now() < entryDatePlusHour){
                    throw new DATA_ERROR("Email Already Used", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)
                }
            }
        }
        return true
    }

}