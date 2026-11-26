# DEC-065 — Captura armed en companion Android

**Estado:** ✅ Decidido (2026-11-26)  
**Prioridad:** P0  
**Slices:** 131, 136  
**Relación:** DEC-063 (app Android), DEC-058 (antirrebote en servidor).

## Decisión

- En `apps/scanner_companion`, la cámara **solo bufferiza** el último código válido (dedup local).
- El envío al POS ocurre **solo** cuando el operador pulsa **Escanear** (`CompanionArmedScan.trigger`).
- No hay auto-envío al detectar barras/QR en el visor de productos.
- El servidor mantiene su antirrebote; la app evita dobles envíos accidentales en el mismo gesto.

## Alternativas descartadas

- Auto-send al detectar (comportamiento previo a SLICE-131): duplicaba líneas con lecturas repetidas del visor.
- Confirmación modal por código: frena el flujo en mostrador.

## Impacto

`companion_armed_scan.dart`, `lan_scan_screen.dart`, runbook piloto LAN y APK Android. Sin cambio de contrato WebSocket.