# Luma Marine brand

Full guide (color specimens, logo do/don't, application mockups):
**https://claude.ai/code/artifact/afae41d3-cf24-4f0f-987d-71d698c09905**

Quick reference for anyone touching the UI — the source of truth for the
actual values is `lib/theme/app_theme.dart` (`AppColors`) and
`lib/widgets/luma_logo.dart` (`LumaMark`, `LumaWordmark`, `LumaLogoLockup`);
this file just explains the reasoning behind them.

## Core identity: navy + white, nothing else

Pulled directly from the merchandise line (tees, hoodie, cap, tumbler) —
every piece carries one mark, in white on navy or navy on white. That's the
whole brand. Two colors.

| Token | Hex | Role |
|---|---|---|
| `AppColors.navy` | `#0A1930` | Primary — logo, hero/footer grounds |
| White | `#FFFFFF` | Primary — the other half of the identity |
| `AppColors.navyLight` | `#1C3A5E` | Navy tint, secondary panels |
| `AppColors.navyDark` | `#060F1F` | Navy shade, deepest grounds |
| `AppColors.fog` | `#E7ECEF` | Neutral page background |
| `AppColors.slate` | `#5A6B74` | Secondary text |

## The one addition: a functional UI accent

Steel Teal (`AppColors.seafoam` `#4AA3B5` / `AppColors.seafoamDark`
`#357A8C`) is **not** part of the core brand — it doesn't appear in the
logo or on merchandise. It exists because a strict navy/white interface
can't show what's clickable, active, or in stock. Use it only for that:
primary CTA fills, active nav/tab state, price highlights, status badges.
Pair it with dark navy text, not white. If a use of teal could instead be
solved with navy + spacing + weight, use that instead.

## Type

Inter Tight (weight 700–800) for the wordmark and headlines; Inter
(weight 400–600) for body copy and UI. This matches what's actually
bundled and rendered in the app (`assets/fonts/`) — the guide is a
description of the shipped product, not a separate aspiration.

- Wordmark: `LUMA` uppercase, weight 800, `+0.12em` tracking, with a
  smaller `— MARINE —` line beneath at weight 600, `+0.22em` tracking.
- Headlines: weight 700, `-0.01em` tracking, sentence case.
- Body: weight 400–500, 1.55 line-height.
- Labels/eyebrows: weight 700, uppercase, `+0.14em` tracking.

## Logo

`LumaMark` is a monoline "LM" — a single stroke weight, no fill, drawn as
two paths (the L's spine+foot, the M's four-segment zigzag). Never
recolor it outside navy/white, never stretch it non-uniformly, and give
it clear space equal to its own stroke width on every side. `LumaWordmark`
and the combined `LumaLogoLockup` follow the same two-color rule.
