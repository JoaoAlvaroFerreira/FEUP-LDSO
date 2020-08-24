import express from "express";
import bodyParser from "body-parser";
import logger from "morgan";
import helmet from "helmet";
import compression from "compression";
import session from "express-session";
import redis from "redis";
import connectRedis from "connect-redis";

const Sentry = require("@sentry/node");

import routes from "./routes/";

const app = express();

const redisStore = connectRedis(session);
const redisClient = redis.createClient({
  host: process.env.REDIS_HOST || "127.0.0.1"
});

// Set the Redis session store
app.use(
  session({
    secret: "ktg",
    store: new redisStore({
      host: process.env.REDIS_HOST || "127.0.0.1",
      port: 6379,
      client: redisClient,
      ttl: 260
    }),
    saveUninitialized: false,
    resave: false
  })
);

// Log requests to the console
if (process.env.NODE_ENV !== "test") {
  app.use(logger("dev"));
}

// Use body-parser
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// Use helmet
app.use(helmet());

// Use compression
app.use(compression());

if (process.env.NODE_ENV == "production") {
  Sentry.init({
    dsn: "https://ca0d4b7b3adf4826be01982e5596d481@sentry.io/1833705"
  });

  // The request handler must be the first middleware on the app
  app.use(Sentry.Handlers.requestHandler());
}
// Root router
app.use(routes);

if (process.env.NODE_ENV == "production") {
  // The error handler must be before any other error middleware and after all controllers
  app.use(Sentry.Handlers.errorHandler());
}

export { app, redisClient };
