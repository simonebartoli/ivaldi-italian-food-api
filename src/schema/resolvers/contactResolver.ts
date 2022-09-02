import {Arg, Mutation, Resolver} from "type-graphql";
import {CreateNewContactRequestInput} from "../inputs/createNewContactRequestInput";
import prisma from "../../db/prisma";
import {createEmail_Contact} from "../lib/emailsLib";

@Resolver()
export class ContactResolver {
    @Mutation(returns => Boolean)
    async createNewContactRequest(@Arg("data", returns => CreateNewContactRequestInput) inputData: CreateNewContactRequestInput) {
        const {name, surname, email, phone_number, message} = inputData
        await prisma.contact.create({
            data: {
                name: name,
                surname: surname,
                email: email,
                phone_number: phone_number,
                message: message
            }
        })
        await createEmail_Contact({
            name: name,
            surname: surname,
            email: email,
            phone_number: phone_number,
            message: message,
            to: email
        })
        return true
    }

}