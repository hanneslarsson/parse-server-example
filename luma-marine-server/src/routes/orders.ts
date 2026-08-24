import { Router } from "express";
import { randomUUID, randomInt } from "node:crypto";
import { z } from "zod";
import { articleStore, orderStore, supplierStore } from "../db/stores";
import { requireAdmin } from "../middleware/auth";
import type { OrderItem, OrderStatus } from "../models/types";

export const ordersRouter = Router();

const orderInputSchema = z.object({
  customer: z.object({
    firstName: z.string().min(1),
    lastName: z.string().min(1),
    email: z.string().email(),
    phone: z.string().min(1),
  }),
  shippingAddress: z.object({
    address: z.string().min(1),
    postalCode: z.string().min(1),
    city: z.string().min(1),
    country: z.string().min(1),
  }),
  comment: z.string().optional(),
  items: z
    .array(
      z.object({
        articleId: z.string().min(1),
        quantity: z.number().int().positive(),
      }),
    )
    .min(1),
});

function generateOrderNumber(): string {
  return `LM-${randomInt(100000, 999999)}`;
}

// Public: the storefront's checkout submits here. Prices/names/suppliers are
// always resolved server-side from the current article record — never taken
// from the client — so a tampered request can't under-price an order.
ordersRouter.post("/public/orders", async (req, res) => {
  const parsed = orderInputSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid order payload", details: parsed.error.issues });
    return;
  }

  const supplierById = new Map(supplierStore.all().map((s) => [s.id, s]));
  const items: OrderItem[] = [];
  for (const line of parsed.data.items) {
    const article = articleStore.getById(line.articleId);
    if (!article || article.discontinued) {
      res.status(400).json({ error: `Article ${line.articleId} is not available` });
      return;
    }
    const supplier = supplierById.get(article.supplierId);
    items.push({
      articleId: article.id,
      sku: article.sku,
      name: article.name,
      supplierId: article.supplierId,
      supplierName: supplier?.name ?? "Unknown supplier",
      quantity: line.quantity,
      unitPriceSek: article.priceSek,
    });
  }

  const subtotalSek = items.reduce((sum, item) => sum + item.unitPriceSek * item.quantity, 0);

  const order = await orderStore.insert({
    id: randomUUID(),
    orderNumber: generateOrderNumber(),
    customer: parsed.data.customer,
    shippingAddress: parsed.data.shippingAddress,
    comment: parsed.data.comment?.trim() || null,
    items,
    subtotalSek,
    status: "new" as OrderStatus,
    createdAt: new Date().toISOString(),
  });

  res.status(201).json({ orderNumber: order.orderNumber, id: order.id });
});

const adminOrdersRouter = Router();
adminOrdersRouter.use(requireAdmin);

adminOrdersRouter.get("/", (req, res) => {
  const { status } = req.query;
  let results = orderStore.all();
  if (typeof status === "string" && status) {
    results = results.filter((o) => o.status === status);
  }
  results = [...results].sort((a, b) => b.createdAt.localeCompare(a.createdAt));
  res.json(results);
});

adminOrdersRouter.get("/:id", (req, res) => {
  const order = orderStore.getById(req.params.id);
  if (!order) {
    res.status(404).json({ error: "Order not found" });
    return;
  }
  res.json(order);
});

const statusSchema = z.object({
  status: z.enum(["new", "processing", "shipped", "cancelled"]),
});

adminOrdersRouter.put("/:id/status", async (req, res) => {
  const parsed = statusSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid status payload" });
    return;
  }
  const updated = await orderStore.update(req.params.id, { status: parsed.data.status });
  if (!updated) {
    res.status(404).json({ error: "Order not found" });
    return;
  }
  res.json(updated);
});

export { adminOrdersRouter };
