import express from "express";
const router = express.Router();

import nbaRouter from "./nba";

// /api/v1/sports/
router.get("/", (req, res) => {
  res.status(200).json({ info: "sports root" });
});

// /api/v1/sports/nba/
router.use("/nba", nbaRouter);

export default router;
