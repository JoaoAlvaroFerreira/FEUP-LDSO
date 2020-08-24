import express from "express";
import swaggerUI from "swagger-ui-express";
import YAML from "yamljs";

import authRouter from "./auth";
import userRouter from "./user";
import betRouter from "./bet";
import leagueRouter from "./league";
import sportsRouter from "./sports";
import gamesRouter from "./game";
import invitesRouter from "./invite";

const router = express.Router();

// /api/
router.get("/", (req, res) => {
  res.status(200).send({ info: "ktg-server API root" });
});

// /api/auth
router.use("/auth", authRouter);

// Gate all API endpoints below this line behind /v1
router.use("/v1", router);

// /api/v1/
router.get("/", (req, res) => {
  res.status(200).send({ info: "ktg-server API v1" });
});

// /api/v1/users/
router.use("/users", userRouter);

// /api/v1/bets
router.use("/bets", betRouter);

// /api/v1/leagues
router.use("/leagues", leagueRouter);

// /api/v1/sports/
router.use("/sports", sportsRouter);

// /api/v1/games/
router.use("/games", gamesRouter);

router.use("/invites", invitesRouter);

// /api/v1/docs
router.use(
  "/docs",
  swaggerUI.serve,
  swaggerUI.setup(YAML.load("./src/docs.yaml"), {
    customSiteTitle: "Know the Game API"
  })
);

export default router;
