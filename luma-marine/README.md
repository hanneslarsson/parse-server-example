# Luma Marine

Marine LED lighting solutions for boats under 12 metres — a Flutter Web
storefront for Luma Marine's inventory of LED lights, controllers/dimmers and
curated lighting kits, with buying guides for choosing a full lighting
solution, plus an admin panel for managing it all.

Needs the backend in `../luma-marine-server` running to load the catalog,
settings/banners, and to place/manage orders — see that project's README.
Without it, the storefront will show a "couldn't load the catalog" state.

## Features

**Storefront**
- Swedish (default), Norwegian, Danish and English, with a language switcher.
- Searchable inventory with category and price filters, backed by the admin
  panel's article data (not static/demo data).
- Full webshop flow: browse → product detail → cart → checkout → order
  confirmation, submitting a real order to the backend (no real payment
  processor wired up — clearly labeled as a demo checkout in the UI).
- Date-controlled announcement banners and contact info/opening hours on the
  homepage, both editable from the admin panel.
- Nordic clean marine visual design (navy/seafoam palette, Inter/InterDisplay
  type, bundled locally as fonts).
- A client-side password gate for previewing the site while it's in
  development (see **Preview password** below) — separate from and unrelated
  to admin login.

**Admin panel** (`/admin`, real login against the backend — see
**Admin login** below)
- Settings: support contact info/opening hours, and date-controlled banners
  shown on the homepage.
- Orders: who placed it, shipping address, articles ordered (grouped by
  supplier), quantities, order date, optional comment, and a status you can
  update.
- Articles: list/search/filter, filter or group by supplier, public
  visibility toggle, stock quantity vs. "ordered from supplier on demand",
  create/edit, and mark as discontinued.
- Suppliers: contact info, how to order from them, lead time in days, active
  toggle (an inactive supplier's articles stop showing in the shop), create/
  edit/remove.
- Admin users: create additional admin accounts, deactivate them.

## Running locally

```bash
flutter pub get
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

(`http://localhost:3000` is the default if you omit `--dart-define`, so
`flutter run -d chrome` alone works too as long as the backend is on that
port.)

## Admin login

Log in at `/admin` (e.g. `http://localhost:PORT/#/admin/login` in a local
run) with the bootstrap admin account the backend prints to its console the
first time it starts — see `../luma-marine-server/README.md`.

## Building for the web

```bash
flutter build web --release --no-web-resources-cdn --dart-define=API_BASE_URL=https://your-backend.example.com
```

`--no-web-resources-cdn` bundles CanvasKit and fallback fonts locally instead
of fetching them from Google's CDN at runtime — this avoids a runtime
dependency on an external host being reachable. `API_BASE_URL` must point at
wherever the backend actually ends up deployed — see the backend's README
for deployment options.

## Preview password

This preview build is gated by a simple password screen (`lib/gate/preview_gate.dart`)
so it isn't casually stumbled upon while under development:

```
lumamarine2026
```

This is **not** real access control — the password ships inside the compiled
JS bundle and is trivially readable by anyone who inspects the build. It's
only meant to keep an in-progress preview from being casually found, not to
protect anything sensitive. (Real access control for the admin panel is the
backend login described above.)

## Deployment

`.github/workflows/deploy.yml` builds the app and publishes `build/web` to the
`gh-pages` branch on every push to `main`/`master`. GitHub Pages needs to be
enabled once for the repo (Settings → Pages → Source: `gh-pages` branch) if it
isn't picked up automatically. The build uses
`--base-href "/${{ github.event.repository.name }}/"`, so it adapts
automatically to whichever repository it's hosted in.

This workflow does **not** currently pass `API_BASE_URL` — until the backend
is deployed somewhere reachable and that's wired into the workflow, a
GitHub Pages build will load but show connection errors for the catalog,
banners, checkout and admin panel.

## Localization

UI strings live in `lib/l10n/app_{sv,en,no,da}.arb`. After editing them, run:

```bash
flutter gen-l10n
```

Product copy (names, descriptions, spec values) is translated in the
backend's seed data (`../luma-marine-server/src/data/`) and edited going
forward through the admin panel's article forms, via the same `L10nText`
shape, since it's data rather than app chrome. The admin panel's own UI
is Swedish-only by design — it's an internal tool, not customer-facing.
