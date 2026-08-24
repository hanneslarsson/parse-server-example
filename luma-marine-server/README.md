# Luma Marine — backend

API/admin backend for the Luma Marine storefront: Node.js + TypeScript +
Express, with a JSON-file-per-entity "database" (no external database
required). Handles authentication for the admin panel, site settings and
banners, the article/supplier catalog, and orders placed through the
storefront.

## Running locally

```bash
npm install
cp .env.example .env   # adjust JWT_SECRET etc. as needed
npm run dev            # http://localhost:3000, auto-restarts on change
```

On first run it creates `data-store/` (gitignored — this is the actual
runtime "database", seeded from the data in `src/data/`) and prints a
bootstrap admin login to the console:

```
=============================================================
 First run — bootstrap admin account created:
   email:    admin@lumamarine.se
   password: <random, printed once>
 Save this now — it will not be printed again.
=============================================================
```

Pin it instead of getting a random password by setting
`ADMIN_BOOTSTRAP_EMAIL` / `ADMIN_BOOTSTRAP_PASSWORD` in `.env` before the
first run. To start over with fresh seed data, stop the server and delete
`data-store/`.

## Running the Flutter app against it

The storefront and admin panel both talk to this backend. Point the Flutter
app at it with:

```bash
cd ../luma-marine
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

(`http://localhost:3000` is already the default if you omit the flag.)

## Production build

```bash
npm run build   # compiles to dist/
npm start        # runs dist/index.js
```

Set `PORT`, `JWT_SECRET` (required — the default is a dev placeholder and
the server warns loudly if it's still set), `CORS_ORIGIN` (the deployed
Flutter app's origin), and `DATA_DIR` (where `data-store/` should live —
make sure it's on persistent storage, not an ephemeral filesystem) via
environment variables.

## API overview

- `POST /api/auth/login`, `GET /api/auth/me` — admin auth (JWT, 12h expiry).
- `GET /api/public/settings`, `GET /api/public/articles`,
  `POST /api/public/orders` — read/write endpoints the storefront itself
  uses; no auth required.
- `GET/PUT /api/admin/settings`, full CRUD-ish routes under
  `/api/admin/articles`, `/api/admin/suppliers`, `/api/admin/orders`,
  `/api/admin/users` — all require `Authorization: Bearer <token>` from
  `/api/auth/login`.

## Data model

Each entity is one JSON array (or, for settings, one object) in
`data-store/`, loaded into memory and rewritten on every mutation — see
`src/db/jsonStore.ts`. Seed content (the initial 24 demo articles, 5
suppliers, contact/banner settings) lives in `src/data/` and is only used
the first time each file is created; after that, `data-store/` is the
source of truth until you delete it.

This is intentionally simple rather than a "real" database — swap
`JsonStore`/`SingletonStore` for a proper DB client later without touching
the route handlers if traffic ever outgrows it.

## Deploying to BeeByte (or similar)

This wasn't set up yet since it depends on what BeeByte's hosting plan
actually supports:

- **If it can run a persistent Node.js process** (a VPS, or Node-capable
  app hosting): `npm run build && npm start` behind a reverse proxy, with
  `DATA_DIR` pointed at a persistent volume.
- **If it's classic shared hosting (PHP/Apache, no Node process)**: this
  backend won't run there as-is — it would need porting to PHP, or the
  backend would need to live elsewhere (a small VPS, Railway, Fly.io,
  etc.) while the static Flutter build is what's hosted on BeeByte.

Whichever it turns out to be, the Flutter app only needs the backend's
public URL via `--dart-define=API_BASE_URL=...` at build time — nothing
else in the client changes.
