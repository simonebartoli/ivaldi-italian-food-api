import {Arg, Mutation, Query, Resolver} from "type-graphql";
import {User} from "../types/userType";
import prisma from "../../db/prisma";
import {CreateNewUseInputType} from "../inputs/userInputs";

@Resolver()
export class UserResolvers {

    @Query(returns => User)
    async getUserByEmail(@Arg("email") email: string): Promise<(User)>{
        return await prisma.users.findUnique({
            where: {
                email: email
            },
            rejectOnNotFound: true
        })
    }

    @Mutation(type => User)
    async createNewUser(@Arg("data") newUserData: CreateNewUseInputType): Promise<User>{
        return await prisma.users.create({
            data: newUserData
        })
    }
}