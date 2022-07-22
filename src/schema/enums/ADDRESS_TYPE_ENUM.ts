import {registerEnumType} from "type-graphql";

export enum ADDRESS_TYPE_ENUM {
    SHIPPING = "SHIPPING",
    BILLING = "BILLING"
}

registerEnumType(ADDRESS_TYPE_ENUM, {
    name: "ADDRESS_TYPE_ENUM"
});