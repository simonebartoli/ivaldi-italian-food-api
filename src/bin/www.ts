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
import {Context} from "../schema/types/contextType";

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
    context: ({req, res}) => ({
      req: req,
      res: res
    }),
    formatError: (err) => formatError(err),
    formatResponse: (response, context) => {
      if(response.errors?.[0]?.extensions?.["code"] === "AUTH_ERROR"){
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