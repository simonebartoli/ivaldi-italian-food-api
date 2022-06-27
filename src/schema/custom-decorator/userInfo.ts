import {createParamDecorator} from "type-graphql";
import prisma from "../../db/prisma";
import {User} from "../types/graphql/userType";

export function UserInfo() {
    return createParamDecorator(async ({context}: any): Promise<User> => {
        const user_id = context.id

        const userDB = await prisma.users.findUnique({
            where: {
                user_id: user_id
            },
            rejectOnNotFound: true
        })

        return {
            user_id: user_id,
            name: userDB.name,
            surname: userDB.surname,
            email: userDB.email,
            dob: userDB.dob,
            role: userDB.role
        };
    });
}