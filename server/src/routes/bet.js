import express from "express";
const router = express.Router();
const superagent = require("superagent");
const key = "a8f5cf4e3c9c47b68eaefeb39ec50bbe";
const urlSeason = "https://api.sportsdata.io/v3/nba/scores/json/CurrentSeason";
const urlSchedule = "https://api.sportsdata.io/v3/nba/scores/json/Games";
import Games from "../controllers/game";

import Bets from "../controllers/bet";

// /api/v1/bets/
router.get("/", async (req, res) => {
  try {
    const bets = await Bets.all();
    res.status(200).json(bets);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/bets/
router.post("/", async (req, res) => {
  try {
    const bet = await Bets.create(req.body);
    res.status(201).json(bet);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/bets/:id
router.get("/:id", async (req, res) => {
  try {
    const bet = await Bets.findById(req.params.id);
    res.status(200).json(bet);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/bets/users/:userId
router.get("/users/:userId", async (req, res) => {
  try {
    const bets = await Bets.findByUser(req.params.userId);

    superagent
      .get(urlSeason)
      .query({ key: key })
      .end((err, season) => {
        superagent
          .get(urlSchedule + "/" + season.body.Season)
          .query({ key: key })
          .end(async (err, resGames) => {
            bets.forEach(async bet => {
              const y = await Games.findById(bet.GameId);
              var games = [];
              for (var k = 0; k < resGames.body.length; k++) {
                if (resGames.body[k].GameID == y.GameID)
                  games.push(resGames.body[k]);
              }
              games.forEach(async game => {
                if (game.IsClosed == true) {
                  const homeScore = game.HomeTeamScore;
                  const awayScore = game.AwayTeamScore;
                  const diffGame = homeScore - awayScore;
                  const homeBetScore = bet.homeTeamScore;
                  const awayBetScore = bet.awayTeamScore;
                  const diffBet = homeBetScore - awayBetScore;
                  var points;
                  if (homeScore == homeBetScore && awayScore == awayBetScore) {
                    points = 10;
                  } else if (
                    (diffGame > 0) & (diffBet > 0) ||
                    (diffGame < 0) & (diffBet < 0) ||
                    (diffGame == 0) & (diffBet == 0)
                  ) {
                    points = 7;
                  } else {
                    points = 0;
                  }
                  bet.points = points;
                  await bet.save();
                }
              });
            });
            const newBets = await Bets.findByUser(req.params.userId);
            res.status(200).json(newBets);
          });
      });
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/bets/:id
router.put("/:id", async (req, res) => {
  try {
    const bet = await Bets.update(req.params.id, req.body);
    res.status(200).json(bet);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/bets/:id
router.delete("/:id", async (req, res) => {
  try {
    const bet = await Bets.findById(req.params.id);
    await Bets.deleteById(req.params.id);
    res.status(200).json(bet);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

export default router;
