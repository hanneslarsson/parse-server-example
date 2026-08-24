import bcrypt from "bcryptjs";
import { config } from "../config";
import type { AdminUser } from "../models/types";

export function buildSeedUsers(): AdminUser[] {
  const now = new Date().toISOString();
  return [
    {
      id: "admin-bootstrap",
      email: config.adminBootstrapEmail,
      passwordHash: bcrypt.hashSync(config.adminBootstrapPassword, 10),
      name: "Admin",
      active: true,
      createdAt: now,
    },
    {
      id: "admin-mattias",
      email: "mattias",
      passwordHash: bcrypt.hashSync(config.mattiasPassword, 10),
      name: "Mattias",
      active: true,
      createdAt: now,
    },
    {
      id: "admin-hannes",
      email: "hannes",
      passwordHash: bcrypt.hashSync(config.hannesPassword, 10),
      name: "Hannes",
      active: true,
      createdAt: now,
    },
  ];
}
