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
    const admin = userStore.all()[0];
    console.log("");
    console.log("=============================================================");
    console.log(" First run — bootstrap admin account created:");
    console.log(`   email:    ${admin.email}`);
    console.log(`   password: ${config.adminBootstrapPassword}`);
    console.log(" Save this now — it will not be printed again.");
    console.log("=============================================================");
    console.log("");
  }
});
