import { Router } from "express";
import { randomUUID } from "node:crypto";
import { z } from "zod";
import { articleStore, supplierStore } from "../db/stores";
import { requireAdmin } from "../middleware/auth";
import type { Article } from "../models/types";

export const articlesRouter = Router();

function publiclyVisibleArticles(): Article[] {
  const activeSupplierIds = new Set(
    supplierStore.filter((s) => s.active && !s.removed).map((s) => s.id),
  );
  return articleStore.filter(
    (a) =>
      a.publiclyVisible && !a.discontinued && activeSupplierIds.has(a.supplierId),
  );
}

// Public: only what the storefront is allowed to show — visible, not
// discontinued, and from a supplier that's currently active.
articlesRouter.get("/public/articles", (_req, res) => {
  const supplierById = new Map(supplierStore.all().map((s) => [s.id, s]));
  const articles = publiclyVisibleArticles().map((a) => {
    const supplier = supplierById.get(a.supplierId);
    return {
      ...a,
      leadTimeDays: a.stockMode === "onDemand" ? supplier?.leadTimeDays ?? null : null,
    };
  });
  res.json(articles);
});

const adminArticlesRouter = Router();
adminArticlesRouter.use(requireAdmin);

adminArticlesRouter.get("/", (req, res) => {
  const { supplierId, category, q, publiclyVisible, discontinued } = req.query;
  let results = articleStore.all();
  if (typeof supplierId === "string" && supplierId) {
    results = results.filter((a) => a.supplierId === supplierId);
  }
  if (typeof category === "string" && category) {
    results = results.filter((a) => a.category === category);
  }
  if (typeof publiclyVisible === "string") {
    results = results.filter((a) => a.publiclyVisible === (publiclyVisible === "true"));
  }
  if (typeof discontinued === "string") {
    results = results.filter((a) => a.discontinued === (discontinued === "true"));
  }
  if (typeof q === "string" && q.trim()) {
    const needle = q.trim().toLowerCase();
    results = results.filter(
      (a) =>
        a.sku.toLowerCase().includes(needle) ||
        Object.values(a.name).some((v) => v.toLowerCase().includes(needle)),
    );
  }
  res.json(results);
});

adminArticlesRouter.get("/:id", (req, res) => {
  const article = articleStore.getById(req.params.id);
  if (!article) {
    res.status(404).json({ error: "Article not found" });
    return;
  }
  res.json(article);
});

const l10nSchema = z.object({ sv: z.string(), en: z.string(), no: z.string(), da: z.string() });

const specSchema = z.object({
  key: z.string(),
  value: z.string(),
  localizedValue: l10nSchema.optional(),
});

const articleInputSchema = z.object({
  sku: z.string().min(1),
  supplierId: z.string().min(1),
  category: z.enum(["ledStrips", "navigation", "deckInterior", "controllers", "kits"]),
  name: l10nSchema,
  shortDescription: l10nSchema,
  description: l10nSchema,
  specs: z.array(specSchema),
  priceSek: z.number().nonnegative(),
  publiclyVisible: z.boolean(),
  stockMode: z.enum(["stock", "onDemand"]),
  stockQuantity: z.number().int().nonnegative().nullable(),
  discontinued: z.boolean(),
});

adminArticlesRouter.post("/", async (req, res) => {
  const parsed = articleInputSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid article payload", details: parsed.error.issues });
    return;
  }
  if (!supplierStore.getById(parsed.data.supplierId)) {
    res.status(400).json({ error: "Unknown supplierId" });
    return;
  }
  const now = new Date().toISOString();
  const article = await articleStore.insert({
    id: randomUUID(),
    ...parsed.data,
    createdAt: now,
    updatedAt: now,
  });
  res.status(201).json(article);
});

adminArticlesRouter.put("/:id", async (req, res) => {
  const parsed = articleInputSchema.partial().safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid article payload", details: parsed.error.issues });
    return;
  }
  if (parsed.data.supplierId && !supplierStore.getById(parsed.data.supplierId)) {
    res.status(400).json({ error: "Unknown supplierId" });
    return;
  }
  const updated = await articleStore.update(req.params.id, {
    ...parsed.data,
    updatedAt: new Date().toISOString(),
  });
  if (!updated) {
    res.status(404).json({ error: "Article not found" });
    return;
  }
  res.json(updated);
});

adminArticlesRouter.post("/:id/discontinue", async (req, res) => {
  const updated = await articleStore.update(req.params.id, {
    discontinued: true,
    publiclyVisible: false,
    updatedAt: new Date().toISOString(),
  });
  if (!updated) {
    res.status(404).json({ error: "Article not found" });
    return;
  }
  res.json(updated);
});

export { adminArticlesRouter };
