import {createMethodDecorator} from "type-graphql";

export function RequireNotLogged() {
    return createMethodDecorator(async ({context}: any, next) => {
        const {req} = context
        const tokenCookie = req.cookies.token
        if(tokenCookie !== undefined){

        }
        return next();
    });
}
