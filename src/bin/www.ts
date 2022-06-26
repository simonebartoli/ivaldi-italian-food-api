import "reflect-metadata"
import {ApolloServer} from 'apollo-server-express';
import {ApolloServerPluginDrainHttpServer} from 'apollo-server-core';
import express from 'express';
import http from 'http';
import cors from "cors"
import cookieParser from "cookie-parser";
import {buildSchema} from "type-graphql";
import {formatError} from "../errors/formatError";

async function startApolloServer() {
  const schema = await buildSchema({
    resolvers: [process.cwd() + "/src/schema/resolvers/**/*.{ts,js}"],
  });

  const app = express();
  app.use(cookieParser())
  app.use(cors({
    origin: "https://studio.apollographql.com",
    credentials: true
  }))

  const httpServer = http.createServer(app);
  const server = new ApolloServer({
    schema,
    debug: false,
    formatError: (err) => formatError(err),
    context: ({req, res}) => ({
      req: req,
      res: res
    }),
    csrfPrevention: true,
    cache: "bounded",
    plugins: [
      ApolloServerPluginDrainHttpServer({ httpServer }),
    ],
  });

  await server.start();
  server.applyMiddleware({ app, cors: false});
  await new Promise<void>(resolve => httpServer.listen({ port: 4000 }, resolve));
  console.log(`🚀 Server ready at http://localhost:4000${server.graphqlPath}`);
}

startApolloServer()