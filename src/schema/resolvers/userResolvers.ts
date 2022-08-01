import {Arg, Ctx, Mutation, Query, Resolver} from "type-graphql";
import {User} from "../types/userType";
import prisma from "../../db/prisma";
import {CreateNewUserInput} from "../inputs/createNewUserInput";
import {DATA_ERROR} from "../../errors/DATA_ERROR";
import {DATA_ERROR_ENUM} from "../enums/DATA_ERROR_ENUM";
import bcrypt from "bcrypt"
import {RequireValidAccessToken} from "../custom-decorator/requireValidAccessToken";
import {UserInfo} from "../custom-decorator/userInfo";
import {ChangeEmailInput} from "../inputs/changeEmailInput";
import {ChangePasswordInput} from "../inputs/changePasswordInput";
import {Logger} from "../custom-decorator/logger";
import {TRIGGER_ENUM} from "../enums/TRIGGER_ENUM";
import {DateTime} from "luxon";
import {createRecoverToken, makeRandomToken} from "../lib/accessLib";
import {Context} from "../types/not-graphql/contextType";

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
    async changeEmail(@Ctx() ctx: Context, @UserInfo() user: User, @Arg("data") inputData: ChangeEmailInput): Promise<true> {
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
        await ctx.stripe.customers.update(user.stripe_customer_id!, {
            email: newEmail
        })
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

    @Mutation(type => String)
    async createNewUser(@Arg("data") inputData: CreateNewUserInput, @Ctx() ctx: Context): Promise<string>{
        const name = inputData.name.charAt(0).toUpperCase() + inputData.name.toLowerCase().substring(1)
        const surname = inputData.surname.charAt(0).toUpperCase() + inputData.surname.toLowerCase().substring(1)
        const dob = inputData.dob
        const email = inputData.email.toLowerCase()

        const emailExisting = await prisma.users.findFirst({
            where: {
                OR: [
                    {
                        email: email
                    },
                    {
                        email_to_verify: email
                    }
                ]
            }
        })
        if(emailExisting !== null){
            if(emailExisting.email !== null)
                throw new DATA_ERROR("Email Already Used", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)
            else{
                const entryDate = DateTime.fromJSDate(emailExisting.entry_date)
                const entryDatePlusHour = entryDate.plus({hour: 1})
                if(DateTime.now() < entryDatePlusHour){
                    throw new DATA_ERROR("Email Already Used", DATA_ERROR_ENUM.EMAIL_ALREADY_USED)
                }else{
                    await prisma.users.delete({
                        where: {
                            email_to_verify: email
                        }
                    })
                }
            }
        }

        const hashedPassword = bcrypt.hashSync(inputData.password, 10)
        const result = await prisma.users.create({
            data: {
                name: name,
                surname: surname,
                dob: dob,
                email: null,
                email_to_verify: email,
                password: hashedPassword
            }
        })
        const {user_id, email_to_verify} = result
        await createRecoverToken(user_id, email_to_verify !== null, ctx)
        return makeRandomToken(6)
    }

}