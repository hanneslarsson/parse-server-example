import { Router } from "express";
import { z } from "zod";
import { settingsStore } from "../db/stores";
import { requireAdmin } from "../middleware/auth";
import type { Banner } from "../models/types";

export const settingsRouter = Router();

function isBannerCurrentlyActive(banner: Banner, now: Date): boolean {
  if (!banner.active) return false;
  if (banner.startDate && now < new Date(banner.startDate)) return false;
  if (banner.endDate) {
    const end = new Date(banner.endDate);
    end.setHours(23, 59, 59, 999);
    if (now > end) return false;
  }
  return true;
}

// Public: contact info/hours plus only the banners currently within their
// date window, so the storefront doesn't need to know about scheduling.
settingsRouter.get("/public/settings", (_req, res) => {
  const settings = settingsStore.get();
  const now = new Date();
  res.json({
    contactEmail: settings.contactEmail,
    contactPhone: settings.contactPhone,
    openingHours: settings.openingHours,
    activeBanners: settings.banners.filter((b) => isBannerCurrentlyActive(b, now)),
  });
});

settingsRouter.get("/admin/settings", requireAdmin, (_req, res) => {
  res.json(settingsStore.get());
});

const l10nSchema = z.object({
  sv: z.string(),
  en: z.string(),
  no: z.string(),
  da: z.string(),
});

const bannerSchema = z.object({
  id: z.string(),
  message: l10nSchema,
  startDate: z.string().nullable(),
  endDate: z.string().nullable(),
  active: z.boolean(),
});

const settingsUpdateSchema = z.object({
  contactEmail: z.string().email(),
  contactPhone: z.string().min(1),
  openingHours: l10nSchema,
  banners: z.array(bannerSchema),
});

settingsRouter.put("/admin/settings", requireAdmin, async (req, res) => {
  const parsed = settingsUpdateSchema.safeParse(req.body);
  if (!parsed.success) {
    res.status(400).json({ error: "Invalid settings payload", details: parsed.error.issues });
    return;
  }
  const updated = await settingsStore.set({
    ...parsed.data,
    updatedAt: new Date().toISOString(),
  });
  res.json(updated);
});
