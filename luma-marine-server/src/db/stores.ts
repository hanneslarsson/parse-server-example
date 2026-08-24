import { config } from "../config";
import { JsonStore } from "./jsonStore";
import { SingletonStore } from "./singletonStore";
import { seedArticles } from "../data/seedArticles";
import { seedSuppliers } from "../data/seedSuppliers";
import { seedSettings } from "../data/seedSettings";
import { buildSeedUsers } from "../data/seedUsers";
import type { Article, Supplier, Order, Settings, AdminUser } from "../models/types";

export const articleStore = new JsonStore<Article>(
  config.dataDir,
  "articles",
  seedArticles,
);

export const supplierStore = new JsonStore<Supplier>(
  config.dataDir,
  "suppliers",
  seedSuppliers,
);

export const orderStore = new JsonStore<Order>(config.dataDir, "orders", []);

export const settingsStore = new SingletonStore<Settings>(
  config.dataDir,
  "settings",
  seedSettings,
);

export const userStore = new JsonStore<AdminUser>(
  config.dataDir,
  "users",
  buildSeedUsers(),
);
