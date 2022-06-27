import express from "express";

export type Context = {
    req: express.Request,
    res: express.Response,
    id: number | null
}