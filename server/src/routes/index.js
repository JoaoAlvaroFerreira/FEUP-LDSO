import express from "express";
const router = express.Router();

import apiRouter from "./api";

// /
router.get("/", (req, res) =>
  res.status(200).send({
    info: "Root endpoint. See /api/v1 for API"
  })
);

// /api/
router.use("/api", apiRouter);

// Undefined routes
router.use((req, res) =>
  res.status(404).send({
    info: "Not found"
  })
);

export default router;
