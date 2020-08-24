import express from "express";
const router = express.Router();
const superagent = require("superagent");
const key = "a8f5cf4e3c9c47b68eaefeb39ec50bbe";
const urlSeason = "https://api.sportsdata.io/v3/nba/scores/json/CurrentSeason";
const urlSchedule = "https://api.sportsdata.io/v3/nba/scores/json/Games";
import Games from "../controllers/game";

import Leagues from "../controllers/league";
import Users from "../controllers/user";

// /api/v1/leagues/
router.get("/", async (req, res) => {
  try {
    const leagues = await Leagues.all();
    res.status(200).json(leagues);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/leagues/
router.post("/", async (req, res) => {
  try {
    const league = await Leagues.create(req.body);
    league.setUsers(league.CreatorId);
    res.status(201).json(league);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/leagues/:id
router.get("/:id", async (req, res) => {
  try {
    const league = await Leagues.findById(req.params.id);
    res.status(200).json(league);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/leagues/:id
router.put("/:id", async (req, res) => {
  try {
    const league = await Leagues.update(req.params.id, req.body);
    res.status(200).json(league);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/leagues/:id
router.delete("/:id", async (req, res) => {
  try {
    const league = await Leagues.deleteById(req.params.id);
    res.status(200).json(league);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

//get leagues' users
// /api/v1/leagues/:id/users
router.get("/:id/users", async (req, res) => {
  try {
    const league = await Leagues.findById(req.params.id);
    const users = await league.getUsers();
    res.status(200).json(users);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

//get leagues' games
// /api/v1/leagues/:id/games
router.get("/:id/games", async (req, res) => {
  try {
    const league = await Leagues.findById(req.params.id);
    const games = await league.getGames();
    superagent
      .get(urlSeason)
      .query({ key: key })
      .end((err, season) => {
        superagent
          .get(urlSchedule + "/" + season.body.Season)
          .query({ key: key })
          .end(async (err, res1) => {
            try {
              for (var i = 0; i < res1.body.length; i++) {
                const game = res1.body[i];
                for (var j = 0; j < games.length; j++) {
                  if (games[j].GameID == game.GameID) {
                    await Games.update(games[j].id, game);
                  }
                }
              }
              res.status(201).json(games);
            } catch (err) {
              res.status(500).json({ error: err });
            }
          });
      });
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

//delete a user from a league
// /api/v1/leagues/:id/user
router.delete("/:id/:userId", async (req, res) => {
  try {
    const league = await Leagues.findById(req.params.id);
    const user = await Users.findById(req.params.userId);
    await league.removeUser(user);
    res.status(201).json(user.id);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

export default router;
