import {registerEnumType} from "type-graphql";

export enum ORDER_STATUS_ENUM {
    REQUIRES_PAYMENT = "REQUIRES_PAYMENT",
    CONFIRMED = "CONFIRMED",
    DELIVERED = "DELIVERED",
    CANCELLED = "CANCELLED",
    REFUNDED = "REFUNDED"
}

registerEnumType(ORDER_STATUS_ENUM, {
    name: "ORDER_STATUS_ENUM"
});
