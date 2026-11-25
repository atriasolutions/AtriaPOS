# 23b — Gate R4-B · Respuestas Bloque B (companion web WiFi)

**Estado:** ✅ cerrado documentalmente (2026-11-25)  
**Base:** workshop Bloque B + plan Gate R4-B; decisiones en [DEC-056…058](decisiones/DEC-gate-r4-b-bloque-b.md).

---

## 1. Alcance y slices

| # | Respuesta |
|---|-----------|
| 1 | Tabla **SLICE-95…105** en [22-plan-companion-web.md](22-plan-companion-web.md). |
| 2 | Companion en **Vender**, **ingreso** (`receiptScan`) y **conteo** (`countScan`). |
| 3 | **POS** se adapta (QR, servidor LAN) en slices 99+. |
| 4 | BLE companion **reemplazado**; retirada UI por defecto en slice 104. |

## 2. Red y hosting

| # | Respuesta |
|---|-----------|
| 5 | Servidor **embebido** en `pos_app`; no sidecar. |
| 6 | Puerto default **8765**; supervisor puede cambiar puerto **[INFERIDO]** persistencia en slice posterior. |
| 7 | Solo **red local**; sin exposición Internet. |
| 8 | **HTTP** sin TLS en MVP (DEC-056); TLS si spike cámara falla. |

## 3. Descubrimiento y auth

| # | Respuesta |
|---|-----------|
| 9 | **QR por contexto** en POS (URL + `storeId` + `mode` + `pairingCode`). |
| 10 | `POST .../companion/pair` → token + `wsPath`. |
| 11 | **Un dispositivo** activo; revocación al re-emparejar. |
| 12 | Token TTL **30 min** desde emparejamiento exitoso. |

## 4. Escaneo

| # | Respuesta |
|---|-----------|
| 13 | v1 **cámara** en PWA Android; HID fuera de MVP. |
| 14 | Mismo codec payload que BLE (`decodeScanPayload`). |
| 15 | Antirrebote **400 ms** en servidor antes de propagar. |
| 16 | Ingreso: guía/lote en **companion** tras pair (MVP) **[REVISAR]** vs POS pre-llena. |

## 5. Riesgos

| # | Respuesta |
|---|-----------|
| 17 | **Cámara + HTTP:** spike manual SLICE-95b; si Chrome bloquea, slice TLS o workaround documentado. |
| 18 | Sin datos de pago ni certificados en companion. |