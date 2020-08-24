import express from "express";
const router = express.Router();

import Users from "../controllers/user";

// /api/v1/users/
router.get("/", async (req, res) => {
  try {
    const users = await Users.all();
    res.status(200).json(users);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/users/otherUsers
router.get("/:id/otherUsers", async (req, res) => {
  try {
    const users = await Users.others(req.params.id);
    res.status(200).json(users);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/users/loggedIn
router.get("/loggedIn", async (req, res) => {
  try {
    const user = await Users.findById(req.session.user.id);
    res.status(200).json(user);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/users/:id
router.get("/:id", async (req, res) => {
  try {
    const user = await Users.findById(req.params.id);
    if (!user) res.status(404).send();
    else res.status(200).json(user);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/users/:id
router.put("/:id", async (req, res) => {
  try {
    const user = await Users.update(req.params.id, req.body);
    res.status(200).json(user);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/users/:id
router.delete("/:id", async (req, res) => {
  try {
    const user = await Users.deleteById(req.params.id);
    res.status(200).json(user);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/v1/users/:id/leagues
router.get("/:id/leagues", async (req, res) => {
  try {
    const user = await Users.findById(req.params.id);
    const league = await user.getLeagues();
    res.status(200).json(league);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/users/addFriend
router.post("/:id/addFriend", async (req, res) => {
  try {
    const user = await Users.findById(req.params.id);
    const friend = await Users.findById(req.body.friendId);
    await friend.addFriend(user);
    await user.addFriend(friend);
    res.status(200).json(friend.id);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});

// /api/v1/users/:id/friends
/*router.get("/:id/friends", async (req, res) => {
  try {
    const user = await Users.findById(req.params.id);
    const res = await user.getFriends();
    res.status(200).json(res);
  } catch (err) {
    res.status(404).json({ error: err });
  }
});*/

export default router;
