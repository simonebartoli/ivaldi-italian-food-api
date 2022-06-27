import {createMethodDecorator} from "type-graphql";
import {TokenPayloadType} from "../types/tokenType";
import * as jose from "jose";
import {DateTime} from "luxon";
import prisma from "../../db/prisma";
import {TRIGGER_ENUM} from "../enums/TRIGGER_ENUM";

export function Logger(trigger: TRIGGER_ENUM) {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const accessToken = req.headers.authorization.split(" ")[1]
        const {id} = <TokenPayloadType> jose.decodeJwt(accessToken)
        const datetime = DateTime.now().toJSDate()
        const ip = req.socket.remoteAddress || req.ip

        await prisma.log_accesses.create({
            data: {
                ip: ip,
                trigger: trigger,
                datetime: datetime,
                user_id: id
            }
        })
        return next();
    });
}
