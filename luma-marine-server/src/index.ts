import express from "express";
import cors from "cors";
import { config } from "./config";
import { authRouter } from "./routes/auth";
import { settingsRouter } from "./routes/settings";
import { articlesRouter, adminArticlesRouter } from "./routes/articles";
import { suppliersRouter } from "./routes/suppliers";
import { ordersRouter, adminOrdersRouter } from "./routes/orders";
import { usersRouter } from "./routes/users";
import { userStore } from "./db/stores";

const app = express();
app.use(cors({ origin: config.corsOrigin }));
app.use(express.json());

app.get("/api/health", (_req, res) => res.json({ status: "ok" }));

app.use("/api/auth", authRouter);
app.use("/api", settingsRouter);
app.use("/api", articlesRouter); // public /api/public/articles
app.use("/api/admin/articles", adminArticlesRouter);
app.use("/api/admin/suppliers", suppliersRouter);
app.use("/api", ordersRouter); // public /api/public/orders
app.use("/api/admin/orders", adminOrdersRouter);
app.use("/api/admin/users", usersRouter);

app.use((req, res) => {
  res.status(404).json({ error: `No route for ${req.method} ${req.path}` });
});

app.listen(config.port, () => {
  console.log(`[luma-marine-server] listening on http://localhost:${config.port}`);
  if (userStore.wasSeeded) {
    const passwordsByEmail: Record<string, string> = {
      [config.adminBootstrapEmail]: config.adminBootstrapPassword,
      mattias: config.mattiasPassword,
      hannes: config.hannesPassword,
    };
    console.log("");
    console.log("=============================================================");
    console.log(" First run — bootstrap admin accounts created:");
    for (const user of userStore.all()) {
      console.log(`   ${user.email} / ${passwordsByEmail[user.email]}`);
    }
    console.log(" Save these now — they will not be printed again.");
    console.log(" (Unset MATTIAS_PASSWORD/HANNES_PASSWORD/ADMIN_BOOTSTRAP_PASSWORD");
    console.log("  in .env get a random password here; set them to pin your own.)");
    console.log("=============================================================");
    console.log("");
  }
});
