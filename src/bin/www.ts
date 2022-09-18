import "reflect-metadata"
import {ApolloServer} from 'apollo-server-express';
import {ApolloServerPluginDrainHttpServer} from 'apollo-server-core';
import express from 'express';
import http from 'http';
import cors from "cors"
import cookieParser from "cookie-parser";
import {buildSchema} from "type-graphql";
import {formatError} from "../errors/formatError";
import {setHttpPlugin} from "../plugins/sendResponse";
import {Context} from "../schema/types/not-graphql/contextType";
import {redisClient} from "../db/redis";
import Stripe from "stripe";
import {DOMAIN, PDF_FONTS, STRIPE_SECRET_KEY} from "./settings";
import PdfPrinter from "pdfmake"
import {initKeyRotation} from "./init-key-rotation";
import {uploadRouter} from "../REST/uploadFiles";
import fileUpload from "express-fileupload";
import path from "path";

const PdfGenerator = new PdfPrinter(PDF_FONTS)
export const secureUploadLink = new Map<string, Date>()
initKeyRotation()

async function startApolloServer() {
    const stripe = new Stripe(STRIPE_SECRET_KEY, {apiVersion: '2020-08-27'})
    try{
        await redisClient.connect();
    }catch (e) {
        console.log(e)
    }

    const schema = await buildSchema({
        resolvers: [process.cwd() + (process.env["NODE_ENV"] === "production" ? "/build/src/schema/resolvers/**/*.{ts,js}" : "/src/schema/resolvers/**/*.{ts,js}")],
    });
    const app = express();
    app.use(fileUpload({
        abortOnLimit: true,
        limits: { fileSize: 2 * 1024 * 1024 },
        useTempFiles : true,
        tempFileDir : path.join(process.cwd() + "/images/tmp/")
    }));
    app.use(express.json())
    app.use(cookieParser())
    app.use(cors({
        origin: DOMAIN,
        credentials: true
    }))
    app.use(express.static("receipts-pdf"))
    app.use("/images", express.static("images"))
    app.use(uploadRouter)


    const httpServer = http.createServer(app);

    const server = new ApolloServer({
        schema,
        debug: false,
        context: ({req, res}) : Context => ({
            req: req,
            res: res,
            redis: redisClient,
            role: null,
            user_id: null,
            stripe: stripe,
            PdfGenerator: PdfGenerator
        }),
        formatError: (err) => formatError(err),
        formatResponse: (response, context) => {
            if(response.errors?.[0]?.extensions?.["code"] === "AUTH_ERROR" && response.errors?.[0]?.extensions?.["destroy"]){
                const {res} = <Context> context.context
                res.clearCookie("token", {
                    sameSite: "none",
                    secure: false
                })
            }
            return null
        },
        csrfPrevention: true,
        cache: "bounded",
        plugins: [
            ApolloServerPluginDrainHttpServer({ httpServer }),
            setHttpPlugin
        ],
    });

    await server.start();
    server.applyMiddleware({ app, cors: false});
    await new Promise<void>(resolve => httpServer.listen({ port: 4000 }, resolve));
    console.log(`🚀 Server ready at http://localhost:4000${server.graphqlPath}`);
}

startApolloServer()