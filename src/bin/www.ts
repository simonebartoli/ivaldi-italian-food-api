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
import {initRedis} from "./InitRedis";
import {redisClient} from "../db/redis";
import Stripe from "stripe";
import {STRIPE_SECRET_KEY} from "./settings";
import {webhookRouter} from "../webhooks/webhook";

const orderTimeout = new Map<string, ReturnType<typeof setTimeout>>()

async function startApolloServer() {
  const stripe = new Stripe(STRIPE_SECRET_KEY, {apiVersion: '2020-08-27'})
  try{
    // redisClient.on('error', (err) => console.log('Redis Client Error', err));
    await redisClient.connect();
    await initRedis(redisClient)
  }catch (e) {
    console.log(e)
  }

  const schema = await buildSchema({
    resolvers: [process.cwd() + (process.env["NODE_ENV"] === "production" ? "/build/src/schema/resolvers/**/*.{ts,js}" : "/src/schema/resolvers/**/*.{ts,js}")],
  });
  const app = express();
  app.use(cookieParser())
  app.use(cors({
    origin: "http://localhost:3000",
    credentials: true
  }))
  app.use(webhookRouter)

  const httpServer = http.createServer(app);

  const server = new ApolloServer({
    schema,
    debug: false,
    context: ({req, res}) : Context => ({
      req: req,
      res: res,
      redis: redisClient,
      user_id: null,
      stripe: stripe,
      orderTimeout
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