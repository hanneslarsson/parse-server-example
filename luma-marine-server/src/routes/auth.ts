import { Router } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { z } from "zod";
import { config } from "../config";
import { userStore } from "../db/stores";
import { requireAdmin, type AuthedRequest } from "../middleware/auth";

export const authRouter = Router();

// Login identifier can be an email or a plain username (e.g. "mattias") —
// AdminUser.email is really just a unique login identifier, not necessarily
// an email address.
const loginSchema = z.object({
  email: z.string().min(1),
  password: z.string().min(1),
});

authRouter.post("/login", (req, res) => {
  const parsed = loginSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid request body" });
    return;
  }
  const { email, password } = parsed.data;
  const user = userStore.find(
    (u) => u.email.toLowerCase() === email.toLowerCase(),
  );
  if (!user || !user.active || !bcrypt.compareSync(password, user.passwordHash)) {
    res.status(401).json({ error: "Invalid email or password" });
    return;
  }
  const token = jwt.sign({ sub: user.id }, config.jwtSecret, {
    expiresIn: "12h",
  });
  res.json({
    token,
    user: { id: user.id, email: user.email, name: user.name },
  });
});

authRouter.get("/me", requireAdmin, (req: AuthedRequest, res) => {
  const user = userStore.getById(req.adminUserId!);
  if (!user) {
    res.status(404).json({ error: "User not found" });
    return;
  }
  res.json({ id: user.id, email: user.email, name: user.name });
});
