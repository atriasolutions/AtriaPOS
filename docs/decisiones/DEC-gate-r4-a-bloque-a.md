# DEC-052 — Gate R4-A · Sesión de escaneo unificada

**Estado:** ✅ Decidido (2026-11-25)  
**Prioridad:** P0  
**Slices:** 85–89

## Decisión

- Modelo **`ScanSession`** con `kind`: `receiptScan` | `countScan`.
- Estados: `draft`, `confirmed`, `cancelled`.
- Cada código leído en borrador **incrementa +1** en la línea del producto resuelto.
- Antirrebote: segundo mismo código en **&lt; 400 ms** no suma.
- Resolución: `Product.barcode` o `parseProductIdFromScan` (QR).
- Guía/lote obligatorios al **crear** sesión `receiptScan` (normalizados `StockReceiptRefPolicy`).
- Confirmación de stock: slice 86+; slice 85 solo borrador y API.

## Alternativas descartadas

- APIs separadas sin `kind`.
- Persistencia SQLite en slice 85.

## Impacto

docs 04 (RF-094), 07 (API-004), `packages/core` dominio scan.

---

# DEC-053 — Gate R4-A · Canal escaneo operación

**Estado:** ✅  
**Prioridad:** P1

## Decisión

Reutilizar **`ScannerIngress`** en pantallas ingreso/conteo (BLE, wedge, manual). Tests con `StreamScannerIngress`.

---

# DEC-054 — Gate R4-A · Cambio de producto y permiso

**Estado:** ✅  
**Prioridad:** P0  
**Slices:** 90–91

## Decisión

- Nuevo permiso **`cambiarProducto`**: dueño y supervisor (herencia RF-081).
- Ventana: **turno abierto**.
- Agregado dominio **`ProductExchange`** con trazabilidad `saleId` y líneas.

---

# DEC-055 — Gate R4-A · NC, factura y Transbank

**Estado:** ✅  
**Prioridad:** P0  
**Slices:** 92–93

## Decisión

- NC y factura por **`DteGateway`** núcleo; cola DTE compartida; Kora no bloqueante.
- Boleta emitida: anulación vía **NC** (parcial/total), no void directo.
- **Transbank conectado:** excluido bloque; voucher manual excluido de 85–94.

## Impacto

docs 04 RF-096, RF-097; amend RF-050; slice 92+.