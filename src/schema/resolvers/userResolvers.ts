import {Arg, Mutation, Query, Resolver} from "type-graphql";
import {User} from "../types/graphql/userType";
import prisma from "../../db/prisma";
import {CreateNewUseInputType} from "../inputs/userInputs";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import bcrypt from "bcrypt"

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
        const emailExisting = await prisma.users.findFirst({
            where: {
                email: newUserData.email
            }
        })
        if(emailExisting !== null){
            throw new DATA_ERROR("Email Already Used", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)
        }

        const hashedPassword = bcrypt.hashSync(newUserData.password, 10)
        return await prisma.users.create({
            data: {
                ...newUserData,
                email: newUserData.email.toLowerCase(),
                password: hashedPassword
            }
        })
    }

}