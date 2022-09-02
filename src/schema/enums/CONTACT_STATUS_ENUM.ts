import {registerEnumType} from "type-graphql";

export enum CONTACT_STATUS_ENUM {
    RECEIVED = "RECEIVED",
    COMPLETED = "COMPLETED"
}

registerEnumType(CONTACT_STATUS_ENUM, {
    name: "CONTACT_STATUS_ENUM"
});