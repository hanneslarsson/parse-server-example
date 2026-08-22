# Luma Marine

Marine LED lighting solutions for boats under 12 metres — a Flutter Web
storefront for Luma Marine's inventory of LED lights, controllers/dimmers and
curated lighting kits, with buying guides for choosing a full lighting
solution.

Built as a static Flutter web app with local demo data — no backend required.

## Features

- Storefront in Swedish (default), Norwegian, Danish and English, with a
  language switcher.
- Searchable inventory (24 demo products) with category and price filters.
- Full webshop flow: browse → product detail → cart → checkout (demo, no
  real payment) → order confirmation.
- Nordic clean marine visual design (navy/seafoam palette, Inter/InterDisplay
  type, bundled locally as fonts).
- A client-side password gate for previewing the site while it's in
  development (see **Preview password** below).

## Running locally

```bash
flutter pub get
flutter run -d chrome
```

## Building for the web

```bash
flutter build web --release --no-web-resources-cdn
```

`--no-web-resources-cdn` bundles CanvasKit and fallback fonts locally instead
of fetching them from Google's CDN at runtime — this avoids a runtime
dependency on an external host being reachable.

## Preview password

This preview build is gated by a simple password screen (`lib/gate/preview_gate.dart`)
so it isn't casually stumbled upon while under development:

```
lumamarine2026
```

This is **not** real access control — the password ships inside the compiled
JS bundle and is trivially readable by anyone who inspects the build. It's
only meant to keep an in-progress preview from being casually found, not to
protect anything sensitive.

## Deployment

`.github/workflows/deploy.yml` builds the app and publishes `build/web` to the
`gh-pages` branch on every push to `main`/`master`. GitHub Pages needs to be
enabled once for the repo (Settings → Pages → Source: `gh-pages` branch) if it
isn't picked up automatically. The build uses
`--base-href "/${{ github.event.repository.name }}/"`, so it adapts
automatically to whichever repository it's hosted in.

## Localization

UI strings live in `lib/l10n/app_{sv,en,no,da}.arb`. After editing them, run:

```bash
flutter gen-l10n
```

Product copy (names, descriptions, spec values) is translated directly in
`lib/data/products_data.dart` and `lib/data/spec_terms.dart` via the small
`L10nText` helper, since it's data rather than app chrome.
