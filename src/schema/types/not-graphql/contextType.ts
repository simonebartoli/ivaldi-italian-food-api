import express from "express";
import {redisType} from "../../../db/redis";
import Stripe from "stripe";
import PdfPrinter from "pdfmake";

export type Context = {
    req: express.Request,
    res: express.Response,
    user_id: number | null,
    redis: redisType
    stripe: Stripe
    PdfGenerator: PdfPrinter
}