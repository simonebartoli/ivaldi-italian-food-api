import {Arg, Mutation, Query, Resolver} from "type-graphql";
import {User} from "../types/graphql/userType";
import prisma from "../../db/prisma";
import {CreateNewUseInput} from "../inputs/createNewUseInput";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import bcrypt from "bcrypt"
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../custom-decorator/userInfo";
import {ChangeEmailInput} from "../inputs/changeEmailInput";

@Resolver()
export class UserResolvers {

    @Query(returns => User)
    @RequireValidAccessToken()
    getUserInfo(@UserInfo() user: User): User{
        return user
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    async changeEmail(@UserInfo() user: User, @Arg("data") inputData: ChangeEmailInput): Promise<true> {
        const {newEmail} = inputData
        const {user_id, email: originalEmail} = user

        if(originalEmail === newEmail) throw new DATA_ERROR("This email is already part of your account", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)

        const emailAlreadyExisting = await prisma.users.findUnique({
            where: {
                email: newEmail
            }
        })
        if(emailAlreadyExisting !== null){
            throw new DATA_ERROR("Email has already been used", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)
        }
        await prisma.users.update({
            where: {
                user_id: user_id
            },
            data: {
                email: newEmail
            }
        })

        return true
    }


    @Mutation(type => User)
    async createNewUser(@Arg("data") inputData: CreateNewUseInput): Promise<User>{
        const emailExisting = await prisma.users.findFirst({
            where: {
                email: inputData.email
            }
        })
        if(emailExisting !== null){
            throw new DATA_ERROR("Email Already Used", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)
        }

        const hashedPassword = bcrypt.hashSync(inputData.password, 10)
        return await prisma.users.create({
            data: {
                ...inputData,
                email: inputData.email.toLowerCase(),
                password: hashedPassword
            }
        })
    }

}