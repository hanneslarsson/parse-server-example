import { Router } from "express";
import { randomUUID } from "node:crypto";
import { z } from "zod";
import { supplierStore } from "../db/stores";
import { requireAdmin } from "../middleware/auth";

export const suppliersRouter = Router();
suppliersRouter.use(requireAdmin);

suppliersRouter.get("/", (req, res) => {
  const includeRemoved = req.query.includeRemoved === "true";
  const suppliers = supplierStore
    .all()
    .filter((s) => includeRemoved || !s.removed);
  res.json(suppliers);
});

suppliersRouter.get("/:id", (req, res) => {
  const supplier = supplierStore.getById(req.params.id);
  if (!supplier) {
    res.status(404).json({ error: "Supplier not found" });
    return;
  }
  res.json(supplier);
});

const supplierInputSchema = z.object({
  name: z.string().min(1),
  address: z.string().min(1),
  contactPerson: z.string().min(1),
  orderMethod: z.string().min(1),
  leadTimeDays: z.number().int().min(0),
  active: z.boolean(),
});

suppliersRouter.post("/", async (req, res) => {
  const parsed = supplierInputSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid supplier payload", details: parsed.error.issues });
    return;
  }
  const now = new Date().toISOString();
  const supplier = await supplierStore.insert({
    id: randomUUID(),
    ...parsed.data,
    removed: false,
    createdAt: now,
    updatedAt: now,
  });
  res.status(201).json(supplier);
});

suppliersRouter.put("/:id", async (req, res) => {
  const parsed = supplierInputSchema.partial().safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid supplier payload", details: parsed.error.issues });
    return;
  }
  const updated = await supplierStore.update(req.params.id, {
    ...parsed.data,
    updatedAt: new Date().toISOString(),
  });
  if (!updated) {
    res.status(404).json({ error: "Supplier not found" });
    return;
  }
  res.json(updated);
});

// Soft delete: mark as removed rather than physically deleting, so
// historical orders/articles still resolve the supplier's name.
suppliersRouter.post("/:id/remove", async (req, res) => {
  const updated = await supplierStore.update(req.params.id, {
    removed: true,
    active: false,
    updatedAt: new Date().toISOString(),
  });
  if (!updated) {
    res.status(404).json({ error: "Supplier not found" });
    return;
  }
  res.json(updated);
});
