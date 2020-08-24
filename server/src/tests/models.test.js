import request from "supertest";
import { app, redisClient } from "../app.js";
import models from "../models/index.js";

let createdUser = {};
let createdUser2 = {};
let createdUser3 = {};
let createdBet = {};
let createdLeague = {};
let createdInvite = {};
let createdInvite2 = {};

describe("Users", () => {
  const agent = request.agent(app);

  it("get auth should return a message", async () => {
    const res = await agent.get("/api/auth/");
    // eslint-disable-next-line prettier/prettier
    expect(res.body).toEqual({ info: "ktg-server API auth" });
  });

  it("get no users at first", async () => {
    const res = await agent.get("/api/v1/users");

    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual([]);
  });

  it("create one user with an invalid email", async () => {
    const res = await agent.post("/api/auth/signup").send({
      name: "Wrong email",
      username: "wrongemail",
      email: "wrongemail",
      password: "password"
    });

    expect(res.statusCode).toEqual(500);
  });

  it("create one user", async () => {
    const res = await agent.post("/api/auth/signup").send({
      name: "John Doe",
      username: "johndoe",
      email: "johndoe@example.com",
      password: "password",
      Bets: []
    });

    createdUser = res.body;

    expect(res.statusCode).toEqual(201);
  });

  it("create one user with an existing email", async () => {
    const res = await agent.post("/api/auth/signup").send({
      name: "John Doe Teste",
      username: "johndoeteste",
      email: "johndoe@example.com",
      password: "password"
    });

    expect(res.statusCode).toEqual(500);
  });

  it("get created user", async () => {
    const res = await agent.get(`/api/v1/users/${createdUser.id}`);

    expect(res.statusCode).toEqual(200);
  });

  it("session is stored", async () => {
    const res = await agent.get("/api/auth/session");

    expect(res.statusCode).toEqual(200);
  });

  it("log out", async () => {
    const res = await agent.get("/api/auth/logout");

    expect(res.statusCode).toEqual(200);
  });

  it("log out again should fail with 401", async () => {
    const res = await agent.get("/api/auth/logout");

    expect(res.statusCode).toEqual(401);
  });

  it("get all users should have 1 user", async () => {
    const res = await agent.get("/api/v1/users");

    expect(res.statusCode).toEqual(200);
    expect(res.body.length).toEqual(1);
  });

  it("log in with wrong password should fail with 401", async () => {
    const res = await agent.post("/api/auth/login").send({
      email: "johndoe@example.com",
      password: "wrongpassword"
    });

    expect(res.statusCode).toEqual(401);
  });

  it("log in with nonexistent email should fail with 404", async () => {
    const res = await agent.post("/api/auth/login").send({
      email: "nonexistent@example.com",
      password: "password"
    });

    expect(res.statusCode).toEqual(404);
  });

  it("log in with empty email should fail with 401", async () => {
    const res = await agent.post("/api/auth/login").send({
      password: "wrongpassword"
    });

    expect(res.statusCode).toEqual(401);
  });

  it("log in with right credentials", async () => {
    const res = await agent.post("/api/auth/login").send({
      email: "johndoe@example.com",
      password: "password"
    });

    expect(res.statusCode).toEqual(200);
  });
  it("Add a friend", async () => {
    const user = await agent.post("/api/auth/signup").send({
      name: "John Doe 2",
      username: "johndoe2",
      email: "johndoe2@example.com",
      password: "password"
    });

    createdUser2 = user.body;

    const friend = await agent
      .post(`/api/v1/users/${createdUser.id}/addFriend`)
      .send({
        friendId: createdUser2.id
      });

    expect(friend.statusCode).toEqual(200);
    expect(friend.body).toEqual(createdUser2.id);
  });
});

describe("Leagues", () => {
  const agent = request.agent(app);

  it("get no leagues at first", async () => {
    const res = await agent.get("/api/v1/leagues");

    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual([]);
  });

  it("create a league", async () => {
    const res = await agent.post("/api/v1/leagues").send({
      name: "Feup League",
      competition: "NBA",
      CreatorId: createdUser.id
    });

    createdLeague = res.body;
    expect(res.statusCode).toEqual(201);
  });

  it("get all leagues should have 1 league", async () => {
    const res = await agent.get("/api/v1/leagues");

    expect(res.statusCode).toEqual(200);
    expect(res.body.length).toEqual(1);
  });
});

describe("Invites", () => {
  const agent = request.agent(app);

  it("get no invites at first", async () => {
    const res = await agent.get("/api/v1/invites");

    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual([]);
  });

  it("invite a user to join a league", async () => {
    await agent.post("/api/auth/login").send({
      email: "johndoe@example.com",
      password: "password"
    });

    const res = await agent.post(`/api/v1/invites/`).send({
      LeagueId: createdLeague.id,
      InviteReceivedId: createdUser2.id,
      InviteSentId: createdUser.id
    });

    createdInvite = res.body;

    expect(res.statusCode).toEqual(201);
    expect(res.body.id).toEqual(createdInvite.id);
  });

  it("get sent invites", async () => {
    const res = await agent.get(
      `/api/v1/invites/invitesSent/${createdUser.id}`
    );
    expect(res.statusCode).toEqual(200);
    expect(res.body.length).toEqual(1);
  });

  it("get sent invites", async () => {
    await agent.post("/api/auth/login").send({
      email: "johndoe2@example.com",
      password: "password"
    });
    const res = await agent.get(
      `/api/v1/invites/invitesReceived/${createdUser2.id}`
    );

    expect(res.statusCode).toEqual(200);
    expect(res.body.length).toEqual(1);
  });

  it("accept invite", async () => {
    await agent.post("/api/auth/login").send({
      email: "johndoe2@example.com",
      password: "password"
    });

    const res = await agent
      .post(`/api/v1/invites/${createdInvite.id}/acceptDeny/`)
      .send({ UserId: createdUser2.id, acceptance: true });

    expect(res.statusCode).toEqual(201);
    expect(res.body).toEqual(createdInvite.id);
  });

  it("invite other user to join a league", async () => {
    const user = await agent.post("/api/auth/signup").send({
      name: "Richard",
      username: "richard",
      email: "richard@example.com",
      password: "password"
    });

    createdUser3 = user.body;

    const res = await agent.post(`/api/v1/invites/`).send({
      LeagueId: createdLeague.id,
      InviteReceivedId: createdUser3.id,
      InviteSentId: createdUser.id
    });
    createdInvite2 = res.body;

    expect(res.statusCode).toEqual(201);
    expect(res.body.id).toEqual(createdInvite2.id);
  });

  it("deny invite", async () => {
    const res = await agent
      .post(`/api/v1/invites/${createdInvite2.id}/acceptDeny/`)
      .send({ UserId: createdUser3.id, acceptance: false });

    expect(res.statusCode).toEqual(200);
  });

  it("invite the same to join a league, should not allow", async () => {
    const res = await agent.post(`/api/v1/invites/`).send({
      LeagueId: createdLeague.id,
      InviteReceivedId: createdUser2.id,
      InviteSentId: createdUser.id
    });
    expect(res.statusCode).toEqual(500);
  });
});

describe("Leagues", () => {
  const agent = request.agent(app);
  it("get created league's users, ensure it has 2 users", async () => {
    const res = await agent.get(`/api/v1/leagues/${createdLeague.id}/users`);

    expect(res.statusCode).toEqual(200);
    expect(res.body.length).toEqual(2);
  });

  it("update a user, ensure league is updated", async () => {
    const res = await agent.put(`/api/v1/users/${createdUser2.id}`).send({
      username: "peter"
    });
    expect(res.statusCode).toEqual(200);

    const userUpd = await agent.get(
      `/api/v1/leagues/${createdLeague.id}/users`
    );

    expect(userUpd.body[1].username).toEqual("peter");
  });

  it("update a league, ensure user is updated", async () => {
    const res = await agent.put(`/api/v1/leagues/${createdLeague.id}`).send({
      name: "Test Update"
    });

    expect(res.statusCode).toEqual(200);

    const leagueUpd = await agent.get(
      `/api/v1/users/${createdUser.id}/leagues`
    );

    expect(leagueUpd.body[0].name).toEqual("Test Update");
  });
});

describe("Bets", () => {
  const agent = request.agent(app);

  it("get no bets", async () => {
    const res = await agent.get("/api/v1/bets");

    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual([]);
  });

  it("create a bet for user with id 1", async () => {
    await agent.post("/api/auth/login").send({
      email: "johndoe@example.com",
      password: "password"
    });

    const res = await agent
      .post("/api/v1/bets")
      .send({ UserId: createdUser.id, LeagueId: createdLeague.id });

    createdBet = res.body;

    expect(res.statusCode).toEqual(201);
  });

  it("get all bets should have 1 bet", async () => {
    const res = await agent.get("/api/v1/bets");

    expect(res.statusCode).toEqual(200);
    expect(res.body.length).toEqual(1);
  });

  it("get bet with id 1, ensure it has 1 user", async () => {
    const res = await agent.get(`/api/v1/bets/${createdBet.id}`);

    expect(res.statusCode).toEqual(200);
    expect(res.body.UserId).toEqual(createdUser.id);
    expect(res.body.points).toEqual(0);
  });

  it("get user with id 1, ensure it has 1 bet", async () => {
    const res = await agent.get(`/api/v1/users/${createdUser.id}`);

    expect(res.statusCode).toEqual(200);
    expect(res.body.Bets[0].id).toEqual(createdBet.id);
  });

  it("update bet with id 1, ensure the user is updated", async () => {
    const bet = await agent.put(`/api/v1/bets/${createdBet.id}`).send({
      UserId: createdUser2.id
    });

    expect(bet.statusCode).toEqual(200);

    const res = await agent.get(`/api/v1/users/${createdUser.id}`);

    expect(res.statusCode).toEqual(200);
    expect(res.body.Bets.id).toEqual(undefined);

    const res1 = await agent.get(`/api/v1/users/${createdUser2.id}`);

    expect(res1.statusCode).toEqual(200);
    expect(res1.body.Bets[0].id).toEqual(createdBet.id);
  });

  it("delete a user, ensure bet is deleted", async () => {
    const res = await agent.delete(`/api/v1/users/${createdUser2.id}`);

    expect(res.statusCode).toEqual(200);

    const bet = await agent.get(`/api/v1/bets/`);
    expect(bet.body.length).toEqual(0);
  });

  it("delete a bet", async () => {
    await agent.post("/api/auth/login").send({
      email: "johndoe@example.com",
      password: "password"
    });

    const betcreate = await agent
      .post("/api/v1/bets")
      .send({ LeagueId: createdLeague.id });
    createdBet = betcreate.body;

    const betdel = await agent.delete(`/api/v1/bets/${createdBet.id}`);

    expect(betdel.statusCode).toEqual(200);
  });

  it("delete a user from a league", async () => {
    const delUser = await agent.delete(
      `/api/v1/leagues/${createdLeague.id}/${createdUser.id}`
    );
    expect(delUser.statusCode).toEqual(201);
    expect(delUser.body).toEqual(createdUser.id);
  });

  it("delete a league", async () => {
    const res = await agent.delete(`/api/v1/leagues/${createdLeague.id}`);

    expect(res.statusCode).toEqual(200);

    const league = await agent.get(`/api/v1/leagues/`);
    expect(league.body.length).toEqual(0);
  });
});

describe("Sports", () => {
  const agent = request.agent(app);

  it("get sports ", async () => {
    const res = await agent.get("/api/v1/sports");

    expect(res.statusCode).toEqual(200);
    // eslint-disable-next-line prettier/prettier
    expect(res.body).toEqual({ "info": "sports root" });
  });
});

// After all tests are done
afterAll(async done => {
  // Disconnect from Sequelize
  await models.sequelize.close();

  // And disconnect from Redis
  redisClient.unref();

  done();
});
