import {Arg, Ctx, Mutation, Resolver} from "type-graphql";
import {AccessType} from "../types/graphql/accessType";
import {LoginWithPasswordInputs} from "../inputs/loginWithPasswordInputs";
import prisma from "../../db/prisma";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import bcrypt from "bcrypt";
import {Context} from "../types/contextType";
import {DateTime} from "luxon";
import * as jose from 'jose'
import * as fs from "fs";
import {PrivateKeyType} from "../types/keyType";
import {KeyLike} from "jose";
import {RequireNotLogged} from "../custom-decorator/requireNotLogged";

@Resolver()
export class AccessResolvers {

    @Mutation(returns => AccessType)
    @RequireNotLogged()
    async loginWithPassword(@Arg("credentials") credentials: LoginWithPasswordInputs, @Ctx() ctx: Context): Promise<AccessType> {
        const {email, password} = credentials
        const user = await prisma.users.findFirst({
            where: {
                email: email.toLowerCase()
            }
        })
        if(user === null){
            throw new DATA_ERROR("Credentials are invalid", DATA_ERROR_ENUM.INVALID_CREDENTIALS)
        }
        if(!bcrypt.compareSync(password, user.password)){
            throw new DATA_ERROR("Credentials are invalid", DATA_ERROR_ENUM.INVALID_CREDENTIALS)
        }
        await this.createRefreshToken(user.user_id, "standard", ctx)
        return {
            accessToken: "GOOD JOB"
        }
    }

    @Mutation(returns => AccessType)
    async createPublicPrivateKeys(): Promise<AccessType>{
        const { publicKey, privateKey } = await jose.generateKeyPair('RS256')
        let privateJwk = await jose.exportJWK(privateKey)
        let publicJwk = await jose.exportJWK(publicKey)
        const kid = this.makeRandomToken(16)

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

        return {
            accessToken: "GOOD JOB"
        }
    }

    async createRefreshToken(
        id: number,
        auth_level: string,
        context: Context
    ){
        const {req, res} = context
        const ip = req.socket.remoteAddress || req.ip
        const UA = req.get('User-Agent')
        const expiryDate = DateTime.now().plus({day: 7}).toSeconds()
        let refreshToken: string = ""

        let privateKeysFile: string = fs.readFileSync(process.cwd() + "/keys/private-keys.json").toString()
        const privateKeys: PrivateKeyType[] = JSON.parse(privateKeysFile)

        for(const privateKey of privateKeys){
            const retired = privateKey.retired
            if(DateTime.now() < DateTime.fromSeconds(retired)){
                const keyLike = <KeyLike> await jose.importJWK(privateKey.content, "RS256")
                refreshToken = await new jose.SignJWT({
                    id: id
                })
                    .setExpirationTime(expiryDate)
                    .setProtectedHeader({
                        ip: ip.toString(),
                        ua: UA,
                        kid: privateKey.kid,
                        auth_level: auth_level,
                        alg: "RS256"
                    })
                    .sign(keyLike)
            }
        }
        res.cookie("token", refreshToken, {
            expires: DateTime.fromSeconds(expiryDate).toJSDate(),
            secure: true,
            sameSite: "none"
        })
    }

    makeRandomToken(length: number) {
        let result           = '';
        const characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        const charactersLength = characters.length;
        for (let i = 0; i < length; i++ ) {
            result += characters.charAt(Math.floor(Math.random() *
                charactersLength));
        }
        return result;
    }
}