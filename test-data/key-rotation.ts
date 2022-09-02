import fs from "fs";
import {DateTime} from "luxon";
import * as jose from "jose";
import {makeRandomToken} from "../src/schema/lib/accessLib";

const checkPublicPrivateKeys = async () => {
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
        console.log((e as Error).message)
        return {
            privateKeys: [],
            publicKeys: []
        }
    }
}
export const createPublicPrivateKeys = async () => {
    const {privateKeys, publicKeys} = await checkPublicPrivateKeys()
    console.log(privateKeys)
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

    fs.writeFileSync(process.cwd() + "/keys/private-keys.json", JSON.stringify([...privateJSON, ...privateKeys]))
    fs.writeFileSync(process.cwd() + "/keys/public-keys.json", JSON.stringify([...publicJSON, ...publicKeys]))
}