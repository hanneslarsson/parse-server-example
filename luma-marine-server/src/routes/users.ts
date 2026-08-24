import { Router } from "express";
import { randomUUID } from "node:crypto";
import bcrypt from "bcryptjs";
import { z } from "zod";
import { userStore } from "../db/stores";
import { requireAdmin } from "../middleware/auth";
import type { AdminUser } from "../models/types";

export const usersRouter = Router();
usersRouter.use(requireAdmin);

function toPublic(user: AdminUser) {
  const { passwordHash: _passwordHash, ...rest } = user;
  return rest;
}

usersRouter.get("/", (_req, res) => {
  res.json(userStore.all().map(toPublic));
});

const createSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1),
  password: z.string().min(8),
});

usersRouter.post("/", async (req, res) => {
  const parsed = createSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid user payload", details: parsed.error.issues });
    return;
  }
  if (userStore.find((u) => u.email.toLowerCase() === parsed.data.email.toLowerCase())) {
    res.status(409).json({ error: "A user with this email already exists" });
    return;
  }
  const user = await userStore.insert({
    id: randomUUID(),
    email: parsed.data.email,
    name: parsed.data.name,
    passwordHash: bcrypt.hashSync(parsed.data.password, 10),
    active: true,
    createdAt: new Date().toISOString(),
  });
  res.status(201).json(toPublic(user));
});

const updateSchema = z.object({
  name: z.string().min(1).optional(),
  active: z.boolean().optional(),
  password: z.string().min(8).optional(),
});

usersRouter.put("/:id", async (req, res) => {
  const parsed = updateSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid user payload", details: parsed.error.issues });
    return;
  }

  if (parsed.data.active === false) {
    const activeAdmins = userStore.filter((u) => u.active);
    const isLastActiveAdmin =
      activeAdmins.length === 1 && activeAdmins[0].id === req.params.id;
    if (isLastActiveAdmin) {
      res.status(400).json({ error: "Cannot deactivate the last active admin user" });
      return;
    }
  }

  const patch: Partial<AdminUser> = {};
  if (parsed.data.name !== undefined) patch.name = parsed.data.name;
  if (parsed.data.active !== undefined) patch.active = parsed.data.active;
  if (parsed.data.password !== undefined) {
    patch.passwordHash = bcrypt.hashSync(parsed.data.password, 10);
  }

  const updated = await userStore.update(req.params.id, patch);
  if (!updated) {
    res.status(404).json({ error: "User not found" });
    return;
  }
  res.json(toPublic(updated));
});
