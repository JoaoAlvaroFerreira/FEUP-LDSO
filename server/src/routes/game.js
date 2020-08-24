import express from "express";
const router = express.Router();

import Games from "../controllers/game";

// /api/v1/games/
router.get("/", async (req, res) => {
  try {
    const bets = await Games.all();
    res.status(200).json(bets);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/games/:id
router.get("/:id", async (req, res) => {
  try {
    const game = await Games.findById(req.params.id);
    res.status(200).json(game);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

export default router;
