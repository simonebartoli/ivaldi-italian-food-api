import {GraphQLError, GraphQLFormattedError} from "graphql";
import {FORMAT_ERROR} from "./FORMAT_ERROR";
import {FORMAT_ERROR_ENUM} from "../schema/enums/FORMAT_ERROR_ENUM";

export const formatError = (err: GraphQLError): GraphQLFormattedError  => {
    if(err.extensions["code"] === "INTERNAL_SERVER_ERROR"){
        if("validationErrors" in err.extensions["exception"]){
            const errors = []
            for(const singleErr of err.extensions["exception"]["validationErrors"]){
                const messages: string[] = Object.values(singleErr.constraints)

                errors.push({
                    property: singleErr.property,
                    messages: messages
                })
            }
            return new FORMAT_ERROR("Validation Error", FORMAT_ERROR_ENUM.VALIDATION_ERROR, errors)
        }
    }
    return err
}