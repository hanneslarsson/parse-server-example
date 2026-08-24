# Luma Marine brand

Full guide, with color specimens and logo do/don't: `/admin/brand` in the
app itself (Admin → Varumärke). The published copy below is a quick text
reference — the source of truth for the actual values is
`lib/theme/app_theme.dart` (`AppColors`) and `lib/widgets/luma_logo.dart`
(`LumaMark`, `LumaWordmark`, `LumaLogoLockup`); this file and the admin
page both read from those.

## Foundation

Luma Marine exists to solve one problem well: finding the right LED
lighting for a boat under 12 metres is harder than it should be —
scattered components, vague specs, and no guidance on what actually works
together on the water. We test and select lighting and controllers that
survive saltwater, vibration, and the Nordic climate, and we pair every
component with the guidance to build a complete, safe, well-lit boat —
not just a parts list.

That focus — precise, dependable, unshowy — is also the design brief. The
identity runs on two colors and one mark, because a lighting company's own
presence shouldn't compete with the product. Navigation lights need to
read correctly at a glance; the brand should too.

## Core identity: navy + white, nothing else

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
`#357A8C`) is **not** part of the core brand — it never appears in the
logo or the wordmark. It exists because a strict navy/white interface
can't show what's clickable, active, or in stock. Use it only for that:
primary CTA fills, active nav/tab state, price highlights, status badges.
Pair it with dark navy text, not white. If a use of teal could instead be
solved with navy + spacing + weight, use that instead.

## Type

InterDisplay (weight 700–800) for the wordmark and headlines; Inter
(weight 400–600) for body copy and UI — exactly the two fonts bundled in
`assets/fonts/` and rendered by the app, not a separate aspiration.

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
