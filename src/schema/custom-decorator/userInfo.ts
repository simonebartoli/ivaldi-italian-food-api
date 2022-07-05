import {createParamDecorator} from "type-graphql";
import prisma from "../../db/prisma";
import {User} from "../types/userType";

export function UserInfo() {
    return createParamDecorator(async ({context}: any): Promise<User> => {
        const user_id = context.user_id

        const userDB = await prisma.users.findUniqueOrThrow({
            where: {
                user_id: user_id
            }
        })

        return {
            user_id: user_id,
            name: userDB.name,
            surname: userDB.surname,
            email: userDB.email,
            email_to_verify: userDB.email_to_verify,
            dob: userDB.dob,
            role: userDB.role,
            stripe_customer_id: userDB.stripe_customer_id
        };
    });
}