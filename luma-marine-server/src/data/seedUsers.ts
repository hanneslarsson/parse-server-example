import bcrypt from "bcryptjs";
import { config } from "../config";
import type { AdminUser } from "../models/types";

export function buildSeedUsers(): AdminUser[] {
  return [
    {
      id: "admin-bootstrap",
      email: config.adminBootstrapEmail,
      passwordHash: bcrypt.hashSync(config.adminBootstrapPassword, 10),
      name: "Admin",
      active: true,
      createdAt: new Date().toISOString(),
    },
  ];
}
