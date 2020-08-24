import express from "express";
const router = express.Router();

import Invites from "../controllers/invite";
import Leagues from "../controllers/league";
import Users from "../controllers/user";

// /api/v1/invites/
router.get("/", async (req, res) => {
  try {
    const invites = await Invites.all();
    res.status(200).json(invites);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/invites/
router.get("/invitesReceived/:userId", async (req, res) => {
  try {
    const invites = await Invites.findByInvitesReceived(req.params.userId);
    res.status(200).json(invites);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/invites/
router.get("/invitesSent/:userId", async (req, res) => {
  try {
    const invites = await Invites.findByInvitesSent(req.params.userId);
    res.status(200).json(invites);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/invites/
router.post("/", async (req, res) => {
  try {
    const user = req.body.InviteReceivedId;
    const league = await Leagues.findById(req.body.LeagueId);
    const users = await league.getUsers();
    for (var i = 0; i < users.length; i++) {
      if (users[i].id == user) {
        throw Error("This user is already a member of the league");
      }
    }
    const invite = await Invites.create(req.body);
    res.status(201).json(invite);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

//accept the invite and add user to the league
//or deny and delete the invite
router.post("/:inviteId/acceptDeny/", async (req, res) => {
  try {
    const invitedReceived = req.body.UserId; //req.session.user.id;
    const acceptance = req.body.acceptance;
    const invite = await Invites.findById(req.params.inviteId);
    if (acceptance == true) {
      const league = await Leagues.findById(invite.LeagueId);
      const user = await Users.findById(invitedReceived);
      await league.addUser(user);
      const inviteDel = await Invites.deleteById(req.params.inviteId);
      res.status(201).json(inviteDel);
    } else {
      const invite = await Invites.deleteById(req.params.inviteId);
      res.status(200).json(invite);
    }
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

export default router;
