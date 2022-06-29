import {Arg, Mutation, Query, Resolver} from "type-graphql";
import {User} from "../types/userType";
import prisma from "../../db/prisma";
import {CreateNewUseInput} from "../inputs/createNewUseInput";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import bcrypt from "bcrypt"
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../custom-decorator/userInfo";
import {ChangeEmailInput} from "../inputs/changeEmailInput";
import {ChangePasswordInput} from "../inputs/changePasswordInput";
import {Logger} from "../custom-decorator/logger";
import {TRIGGER_ENUM} from "../enums/TRIGGER_ENUM";

@Resolver()
export class UserResolvers {

    @Query(returns => User)
    @RequireValidAccessToken()
    @Logger(TRIGGER_ENUM.VIEW_USER_INFO)
    getUserInfo(@UserInfo() user: User): User{
        return user
    }

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @Logger(TRIGGER_ENUM.CHANGE_EMAIL)
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

    @Mutation(returns => Boolean)
    @RequireValidAccessToken()
    @Logger(TRIGGER_ENUM.CHANGE_PASSWORD)
    async changePassword(@UserInfo() user: User, @Arg("data") inputData: ChangePasswordInput): Promise<true>{
        const {user_id} = user
        const {newPassword} = inputData
        const newPasswordHashed = bcrypt.hashSync(newPassword, 10)
        await prisma.users.update({
            where: {
                user_id: user_id
            },
            data: {
                password: newPasswordHashed
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