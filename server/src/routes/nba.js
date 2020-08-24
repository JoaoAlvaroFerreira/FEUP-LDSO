import express from "express";
const router = express.Router();
const superagent = require("superagent");
import Leagues from "../controllers/league";
import Games from "../controllers/game";

const key = "a8f5cf4e3c9c47b68eaefeb39ec50bbe";
const urlSeason = "https://api.sportsdata.io/v3/nba/scores/json/CurrentSeason";
const urlSchedule = "https://api.sportsdata.io/v3/nba/scores/json/Games";
const gamesByDate = "https://api.sportsdata.io/v3/nba/scores/json/GamesByDate";
const teams = "https://api.sportsdata.io/v3/nba/scores/json/teams";
const allTeams = "https://api.sportsdata.io/v3/nba/scores/json/AllTeams";
const playersTeam = "//https://api.sportsdata.io/v3/nba/scores/json/Players";
const player = "https://api.sportsdata.io/v3/nba/scores/json/Player";
const stadiums = "https://api.sportsdata.io/v3/nba/scores/json/Stadiums";

// /api/v1/sports/nba/
router.get("/", (req, res) => {
  res.status(200).json({ info: "NBA root" });
});

// /api/v1/sports/nba/games/:date
router.get("/games/:date", async (req, res) => {
  try {
    superagent
      .get(gamesByDate + "/" + req.params.date)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/games/
router.get("/games", async (req, res) => {
  try {
    superagent
      .get(urlSeason)
      .query({ key: key })
      .end((err, season) => {
        var games = [];
        superagent
          .get(urlSchedule + "/" + season.body.Season)
          .query({ key: key })
          .end((err, res1) => {
            for (var i = 0; i < res1.body.length; i++) {
              const gameStatus = res1.body[i].Status;
              if (gameStatus == "Scheduled") {
                games.push(res1.body[i]);
              }
            }
            res.status(200).json(games);
          });
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

//add game to a league
// /api/v1/sports/nba/addGame
router.post("/addGame", async (req, res) => {
  try {
    const user = req.body.UserId; //req.session.user.id;
    const league = await Leagues.findById(req.body.LeagueId);
    const users = await league.getUsers();
    try {
      for (var i = 0; i < users.length; i++) {
        if (users[i].id == user) {
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
                      if (
                        game.Status == "Scheduled" &&
                        game.GameID == req.body.GameId
                      ) {
                        const gameCreated = await Games.create(game);
                        superagent
                          .get(stadiums)
                          .query({ key: key })
                          .end(async (err, res2) => {
                            for (var j = 0; j < res2.body.length; j++) {
                              if (res2.body[j].StadiumID == game.StadiumID) {
                                gameCreated.Stadium = res2.body[j].Name;
                                await Games.update(gameCreated.id, gameCreated);
                                await league.addGame(gameCreated);
                                res.status(201).json(gameCreated);
                              }
                            }
                          });
                      }
                    }
                  } catch (err) {
                    res.status(500).json({ error: err });
                  }
                });
            });
        }
      }
    } catch (err) {
      res.status(500).json("You do not belong to this league");
    }
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

//update game to a league
//api/v1/sports/nba/:gameId/
router.put("/:gameId", async (req, res) => {
  try {
    const gameById = await Games.findByGameId(req.params.gameId);
    try {
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
                  if (game.GameID == req.params.gameId) {
                    const gameUpdated = await Games.update(gameById.id, game);
                    res.status(201).json(gameUpdated);
                  }
                }
              } catch (err) {
                res.status(500).json({ error: err });
              }
            });
        });
    } catch (err) {
      res.status(500).json("You do not belong to this league");
    }
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get("/currentSeason", async (req, res) => {
  try {
    superagent
      .get(urlSeason)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

router.get("/weekSchedule", async (req, res) => {
  try {
    superagent
      .get(urlSchedule)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/teams
router.get("/teams", async (req, res) => {
  try {
    superagent
      .get(teams)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/AllTeams
router.get("/allTeams", async (req, res) => {
  try {
    superagent
      .get(allTeams)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/teams/:id
router.get("/teams/:id", async (req, res) => {
  try {
    superagent
      .get(teams)
      .query({ key: key })
      .end((err, teams) => {
        for (var i = 0; i < teams.body.length; i++) {
          if (teams.body[i].TeamID == req.params.id) {
            res.status(200).json(teams.body[i]);
          }
        }
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/players
router.get("/players", async (req, res) => {
  try {
    superagent
      .get(playersTeam)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/players/:id
router.get("/teams/:id/players/", async (req, res) => {
  try {
    superagent
      .get(playersTeam + "/" + req.params.id)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/players/:id
router.get("/players/:id", async (req, res) => {
  try {
    superagent
      .get(player + "/" + req.params.id)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/stadiums/
router.get("/stadiums", async (req, res) => {
  try {
    superagent
      .get(stadiums)
      .query({ key: key })
      .end((err, res1) => {
        res.status(200).json(res1.body);
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/sports/nba/stadiums/:id
router.get("/stadiums/:id", async (req, res) => {
  try {
    superagent
      .get(stadiums)
      .query({ key: key })
      .end((err, stadium) => {
        for (var i = 0; i < stadium.body.length; i++) {
          if (stadium.body[i].StadiumID == req.params.id) {
            res.status(200).json(stadium.body[i]);
          }
        }
      });
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

export default router;
