# SLICE-107 — Enlace corto companion QR

## Criterio

El QR del POS apunta a `http(s)://{host}:{port}/c/{pairingCode}`; el servidor LAN resuelve el código y redirige a `/companion/?…` (DEC-060).

## Hecho (automatizado)

- `findOfferByPairingCode`, `ResolveCompanionShortLink`, `buildCompanionShortLinkUrl` (core) — SC-107-01, 02, 05
- `GET /c/{code}` en `CompanionLanServer` — SC-107-03, 04
- QR POS y e2e actualizados (`companion_lan_e2e_test.dart`)

## Piloto manual (opcional)

1. Escanear QR: barra muestra brevemente `/c/XXXXXX` y luego `/companion/?…`
2. Emparejamiento y flujo vender/scan igual que antes

## Fuera de este slice

HTTPS (109), rediseño PWA (108), estado POS conectado (111).