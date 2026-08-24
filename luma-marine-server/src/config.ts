import path from "node:path";
import crypto from "node:crypto";
import dotenv from "dotenv";

dotenv.config();

function randomPassword(): string {
  return crypto.randomBytes(9).toString("base64url");
}

export const config = {
  port: Number(process.env.PORT ?? 3000),
  dataDir: process.env.DATA_DIR
    ? path.resolve(process.env.DATA_DIR)
    : path.join(__dirname, "..", "data-store"),
  jwtSecret: process.env.JWT_SECRET ?? "dev-secret-change-me-in-production",
  corsOrigin: process.env.CORS_ORIGIN ?? "*",
  adminBootstrapEmail: process.env.ADMIN_BOOTSTRAP_EMAIL ?? "admin@lumamarine.se",
  adminBootstrapPassword: process.env.ADMIN_BOOTSTRAP_PASSWORD ?? randomPassword(),
  // Named admin accounts requested for this deployment. Real values belong
  // in a local, gitignored .env — never hardcoded here — so a random
  // password is generated (and printed once on first run, like the
  // bootstrap admin) if the env var isn't set.
  mattiasPassword: process.env.MATTIAS_PASSWORD ?? randomPassword(),
  hannesPassword: process.env.HANNES_PASSWORD ?? randomPassword(),
};

if (config.jwtSecret === "dev-secret-change-me-in-production") {
  // eslint-disable-next-line no-console
  console.warn(
    "[luma-marine-server] Using the default JWT secret. Set JWT_SECRET in your environment before deploying.",
  );
}
