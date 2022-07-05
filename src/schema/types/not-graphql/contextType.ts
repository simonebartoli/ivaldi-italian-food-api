import express from "express";
import {redisType} from "../../../db/redis";
import Stripe from "stripe";

export type Context = {
    req: express.Request,
    res: express.Response,
    user_id: number | null,
    redis: redisType
    stripe: Stripe
}