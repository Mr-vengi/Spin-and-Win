# Bagul Spin & Win

A Flutter mobile app prototype for spinning for gifts, managing a local wallet, and tracking delivery.

## Run & Operate

- `pnpm --filter @workspace/api-server run dev` — run the API server (port 5000)
- `cd artifacts/bagul-spin-win && flutter pub get` — install Flutter dependencies
- `cd artifacts/bagul-spin-win && flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8099` — run the Flutter preview
- `cd artifacts/bagul-spin-win && flutter analyze` — analyze the Flutter app
- `pnpm run typecheck` — full typecheck across all packages
- `pnpm run build` — typecheck + build all packages
- `pnpm --filter @workspace/api-spec run codegen` — regenerate API hooks and Zod schemas from the OpenAPI spec
- `pnpm --filter @workspace/db run push` — push DB schema changes (dev only)
- Required env: `DATABASE_URL` — Postgres connection string

## Stack

- pnpm workspaces, Node.js 24, TypeScript 5.9
- Mobile app: Flutter/Dart, Provider, SharedPreferences, Google Fonts, share_plus
- API: Express 5
- DB: PostgreSQL + Drizzle ORM
- Validation: Zod (`zod/v4`), `drizzle-zod`
- API codegen: Orval (from OpenAPI spec)
- Build: esbuild (CJS bundle)

## Where things live

- `artifacts/bagul-spin-win/` — Flutter/Dart application
- `artifacts/bagul-spin-win/lib/providers/app_state.dart` — local profile, wallet, referral, address, and gift-order state
- `artifacts/bagul-spin-win/lib/screens/` — app screens

## Architecture decisions

- Flutter is kept as requested; this workspace runs it with a custom web-server workflow because the artifact templates do not include Flutter.
- App data uses SharedPreferences for the local prototype; no password is persisted.
- Prize wheel segments are drawn with CustomPainter to keep the spinner native and dependency-light.

## Product

Bagul Spin & Win includes local demo sign-in, a ₹345 starting wallet, three paid levels, an animated prize wheel, gift claiming with a required delivery address, referral rewards, and order tracking.

## User preferences

The app should remain Flutter/Dart, matching the supplied brief.

## Gotchas

- The Flutter web preview uses port 8099 because the API server already occupies 8080.
- The Replit preview serves the release build; run `flutter build web --release` after UI changes.
- Wallet top-ups, withdrawals, referral verification, and shipping updates are local demo actions, not real payment or fulfillment services.

## Pointers

- See the `pnpm-workspace` skill for workspace structure, TypeScript setup, and package details
