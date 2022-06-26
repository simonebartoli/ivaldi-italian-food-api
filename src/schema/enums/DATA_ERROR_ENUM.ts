import {registerEnumType} from "type-graphql";

export enum DATA_ERROR_ENUM {
    EMAIL_ALREADY_USED = "EMAIL_ALREADY_USED",
    INVALID_CREDENTIALS = "INVALID_CREDENTIALS"
}

registerEnumType(DATA_ERROR_ENUM, {
    name: "DATA_ERROR_ENUM"
});