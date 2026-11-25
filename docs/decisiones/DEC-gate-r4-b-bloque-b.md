# DEC-056 — Gate R4-B · Companion web WiFi en LAN

**Estado:** ✅ Decidido (2026-11-25)  
**Prioridad:** P0  
**Slices:** 95–105

## Decisión

- Companion **PWA Flutter web** (`apps/companion_web`) accede al POS por **WiFi LAN**.
- Servidor **HTTP + WebSocket embebido** en `pos_app` (misma máquina caja), binding `0.0.0.0`.
- **HTTP** en red de confianza (sin TLS en MVP); puerto default **8765**, configurable por tienda **[INFERIDO]**.
- **Reemplazo** progresivo de `apps/scanner_companion` BLE; sin nuevas features BLE.

## Impacto

docs 05 (RNF-041 amend), 06, 07 (API companion LAN), `packages/adapters` servidor, `apps/companion_web`.

---

# DEC-057 — Gate R4-B · Emparejamiento y concurrencia

**Estado:** ✅  
**Prioridad:** P0

## Decisión

- **Un companion activo** por tienda; nuevo emparejamiento **revoca** el anterior.
- **QR por flujo**: `VENDER` | `RECEIPT_SCAN` | `COUNT_SCAN` (código de un solo uso, TTL **30 min** o hasta revocación).
- Token de sesión companion autentica REST/WS hasta expiración.

## Impacto

`packages/core` dominio `CompanionPairing`; POS genera QR por pantalla.

---

# DEC-058 — Gate R4-B · Transporte escaneo LAN

**Estado:** ✅  
**Prioridad:** P1

## Decisión

- **WebSocket** para pushes `{ "type": "scan", "code": "…" }` y heartbeat.
- Modo **VENDER**: WS alimenta **`ScannerIngress`** (misma abstracción DEC-053).
- Modos **ingreso/conteo**: companion usa API `scan-sessions` existente con token companion.
- Entrada v1: **cámara** en navegador Android; spike SLICE-95b valida HTTP vs secure context.

## Impacto

`LanScannerIngress`, amend doc 07.