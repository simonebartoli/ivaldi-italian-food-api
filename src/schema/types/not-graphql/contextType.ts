import express from "express";
import {redisType} from "../../../db/redis";

export type Context = {
    req: express.Request,
    res: express.Response,
    user_id: number | null,
    redis: redisType
}