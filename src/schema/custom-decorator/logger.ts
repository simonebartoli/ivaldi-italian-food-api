import {createMethodDecorator} from "type-graphql";
import {DateTime} from "luxon";
import prisma from "../../db/prisma";
import {TRIGGER_ENUM} from "../enums/TRIGGER_ENUM";

export function Logger(trigger: TRIGGER_ENUM) {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const id = context.id
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
