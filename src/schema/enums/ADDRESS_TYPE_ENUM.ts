import {registerEnumType} from "type-graphql";

export enum ADDRESS_TYPE_ENUM {
    SHIPPING = "SHIPPING",
    BILLING = "BILLING"
}

export enum COUNTRY_ALLOWED_ENUM {
    UNITED_KINGDOM = "United Kingdom",
}

registerEnumType(ADDRESS_TYPE_ENUM, {
    name: "ADDRESS_TYPE_ENUM"
});

registerEnumType(COUNTRY_ALLOWED_ENUM, {
    name: "COUNTRY_ALLOWED_ENUM"
});