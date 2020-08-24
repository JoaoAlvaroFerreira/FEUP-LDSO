import express from "express";
const router = express.Router();

import Users from "../controllers/user";
import authenticate from "../middleware/auth";

// /api/auth/
router.get("/", (req, res) => {
  res.status(200).send({ info: "ktg-server API auth" });
});

// /api/auth/signup
router.post("/signup", async (req, res) => {
  try {
    const user = await Users.create(req.body);

    req.session.user = user;
    res.status(201).json(user);
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/auth/login
router.post("/login", async (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) {
    res.status(401).json({ error: "missing email or password" });
    return;
  }

  try {
    const user = await Users.findByEmail(email);
    if (!user) {
      res.status(404).json({ error: "user doesn't exist" });
      return;
    }

    const match = await user.validatePassword(password);
    if (match) {
      // Set the session key-value pair
      req.session.user = user;
      res.status(200).json(user);
    } else {
      res.status(401).json({ error: "wrong password" });
    }
  } catch (err) {
    res.status(500).json({ error: err });
  }
});

// /api/auth/logout
router.get("/logout", authenticate, (req, res) => {
  // Destroy the session
  req.session.destroy();
  res.status(200).json({ info: "logged out" });
});

// /api/auth/session
router.get("/session", authenticate, (req, res) => {
  res.status(200).json(req.session);
});

export default router;
