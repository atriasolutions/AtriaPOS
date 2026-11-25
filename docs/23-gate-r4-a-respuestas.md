# 23 — Gate R4-A · Respuestas Bloque A (operación y productos)

**Estado:** ✅ cerrado documentalmente (2026-11-25)  
**Base:** cuestionario en plan Gate R4-A; decisiones formalizadas en [DEC-052…055](decisiones/DEC-gate-r4-a-bloque-a.md).  
**Nota:** ítems marcados **[REVISAR]** quedan para confirmación explícita del cliente sin bloquear SLICE-85.

---

## 1. Alcance y slices

| # | Respuesta |
|---|-----------|
| 1 | Se mantiene tabla **SLICE-85…94** en [21-plan-revision-operacion-productos.md](21-plan-revision-operacion-productos.md). NC parcial/total en un solo slice 92; factura API+UI en 93. |
| 2 | **Voucher Transbank sin sync:** ⏸ fuera de 85–94 (revisión posterior). |
| 3 | **Sub-entrega:** Gate **R4-A2** tras SLICE-89 (escaneo) antes de SLICE-90; fiscal 92–93 puede correr tras cambio si hace falta. |
| 4 | NC/factura vía **`DteGateway` núcleo POS**; Kora solo complemento (doc 20b). |
| 5 | Numeración **85–94** fija; en docs se distingue SLICE-88 histórico R2 (RF-088 cierre) del nuevo SLICE-88 Bloque A. |

## 2. Canal de escaneo

| # | Respuesta |
|---|-----------|
| 6 | v1: **BLE companion**, **keyboard wedge**, **campo manual**, **`StreamScannerIngress`** en tests. Cámara: ⏸ post Bloque B web. |
| 7 | Misma abstracción **`ScannerIngress`** en pantallas de ingreso/conteo (DEC-052). |
| 8 | **Barcode** de producto y **payload QR** (`parseProductIdFromScan`). GS1: ⏸. |
| 9 | **Cada bip = +1**; duplicado &lt; 400 ms → **un solo +1** (antirrebote lector). |
| 10 | **Ingreso:** sin turno abierto. **Conteo/cierre:** turno abierto (RF-088). |
| 11 | Acceptance e2e: **Windows**; macOS sin obligación en matriz 12b. |

## 3. Sesión de escaneo

| # | Respuesta |
|---|-----------|
| 12 | Una sesión = **una operación** (ingreso o conteo) hasta confirmar/cancelar. |
| 13 | v1 borrador **en memoria** (repositorio inyectable); persistencia SQLite en slice posterior si piloto lo exige **[REVISAR]**. |
| 14 | DTO unificado con **`kind`**: `receiptScan` \| `countScan` (DEC-052). |
| 15 | Estados `draft` → `confirmed` \| `cancelled`; **idempotencyKey** en confirmación (slice 86+). |
| 16 | Auditoría solo al **confirmar** (no por bip). |
| 17 | Supervisor/dueño puede **editar cantidad** y **quitar línea** en borrador. |

## 4. Semántica cantidad

| # | Respuesta |
|---|-----------|
| 18 | **Cada bip = +1** unidad. |
| 19 | Mismo SKU → **una línea** con `quantity` acumulada. |
| 20 | Sin barcode: **fuera** del flujo escaneo; búsqueda manual en pantalla clásica. |
| 21 | Más unidades que guía → **advertencia** UI; no bloqueo v1 **[REVISAR]**. |

## 5. Ingreso por escaneo

| # | Respuesta |
|---|-----------|
| 22 | **Alta + ingreso:** código desconocido → atajo **Nuevo producto** (RF-010) con barcode precargado (slice 87); no alta automática silenciosa. |
| 23 | Código inexistente → `NO_ENCONTRADO` en API con hint `canCreateProduct` en details (slice 85+). |
| 24 | **Guía y lote por sesión** (una pareja para todo el ingreso). |
| 25 | Misma política **`StockReceiptRefPolicy`**. |
| 26 | Formulario clásico **convive** con modo escaneo. |
| 27 | Permiso **`ajustarInventario`** + feature plantilla `stockReceiptGuiaLote`. |
| 28 | Confirmar → **un movimiento RECEPCION por producto** (qty agregada). |
| 29 | Límite soft **500 líneas** por sesión (validación API). |
| 30 | **Offline-first** local. |

## 6. Inventario por escaneo

| # | Respuesta |
|---|-----------|
| 31 | Alimenta **RF-088** (cierre con turno). |
| 32 | UI cierre inventario **modo escaneo** integrado (misma pantalla, pestaña o paso). |
| 33 | Bip → **+1 contado**; corrección manual permitida. |
| 34 | Cierre “completo”: solo SKU **tocados** envían línea; no escaneados **no** se incluyen (no asumir stock sistema). |
| 35 | Conteo parcial **sí** en v1. |
| 36 | Solo productos tocados en `CloseInventory`. |
| 37 | Un operador por dispositivo; sin bloqueo multiusuario v1. |
| 38 | Historial borrador no confirmado: **no** persistir v1. |

## 7. Alta catálogo

| # | Respuesta |
|---|-----------|
| 39 | Primera vez: **sí**, vía flujo crear producto enlazado. |
| 40 | Pantalla completa RF-010 en v1 (flujo rápido ⏸). |
| 41 | Política barcode duplicado DEC-010 sin cambio. |
| 42 | Ingreso escaneado solo **stock**; precio/costo en alta catálogo. |

## 8. Cambio de producto

| # | Respuesta |
|---|-----------|
| 43 | **Cambio mismo valor** y **con diferencia** (efectivo/otro sin Transbank). |
| 44 | Ventana: **mismo turno abierto**; ventas del turno actual **[REVISAR]** días. |
| 45 | Búsqueda por **`sale_id`**; sin ticket solo supervisor con auditoría. |
| 46 | Cambio **parcial** de línea sí. |
| 47 | Dominio **`ProductExchange`** agregado + movimientos stock enlazados. |
| 48 | Permiso nuevo **`cambiarProducto`** (supervisor/dueño). |
| 49 | Genera **venta nueva** por SKU entregado + reverso stock vendido. |
| 50 | Una línea de venta multilínea: **sí** cambiable aislada. |

## 9. Nota de crédito

| # | Respuesta |
|---|-----------|
| 51 | Sí: flujo **NC + stock** sustituye bloqueo duro en anulación con boleta emitida. |
| 52 | `PENDIENTE_DTE` → anulación actual; `EMITIDA` → **NC electrónica**. |
| 53 | NC **parcial y total** en v1. |
| 54 | Referencia mínima: folio, tipo doc, fecha venta, `saleId`. |
| 55 | Misma **cola DTE** con `documentType` NC. |
| 56 | CAF NC en cert: validar en slice 92; fake en desarrollo. |
| 57 | NC **confirmada por operador**, no automática al escanear cambio. |
| 58 | Devolución pura **sí** (sin cambio) en slice 92. |

## 10. Factura

| # | Respuesta |
|---|-----------|
| 59 | Elección **boleta vs factura en checkout** (slice 93). |
| 60 | Validación **RUT Chile** obligatoria. |
| 61 | Documento desde checkout; no conversión boleta→factura post. |
| 62 | Mismo pipeline DTE, `documentType` factura. |
| 63 | **Cajero** puede emitir factura si plantilla lo permite y datos completos. |

## 11. Ambiente SII

| # | Respuesta |
|---|-----------|
| 64 | **fake → cert** en 92–93; live manual piloto. |
| 65 | Extender runbooks evidencia NC/factura. |
| 66 | Confirmación cliente antes cert NC **[REVISAR]**. |

## 12. Transbank

| # | Respuesta |
|---|-----------|
| 67 | Sin voucher en este bloque. |
| 68 | Diferencia cambio: **EFECTIVO** y **OTRO** (DEC-012). |

## 13. API y persistencia

| # | Respuesta |
|---|-----------|
| 69 | **`API-004` extensión** `scan-sessions` (no namespace nuevo). |
| 70 | Tablas SQLite scan: **postergar** a adapter slice 86; v1 in-memory en core. |
| 71 | Tablas `product_exchanges` / enlaces NC en slices 90–92. |
| 72 | Un bump Drift por grupo (90+, 92+). |

## 14. UI y menú

| # | Respuesta |
|---|-----------|
| 73 | Integrar en **Ingreso existencias** y **Cierre inventario**; menú sin ítems nuevos salvo “Cambio mostrador”. |
| 74 | Sin `PosFeature` nuevos v1; permisos + plantilla actual. |
| 75 | Cajero **sin** conteo ni ingreso escaneo. |

## 15. TDD

| # | Respuesta |
|---|-----------|
| 76 | Core API + e2e en slices **87, 89, 91, 93**; 85–86 core. |
| 77 | e2e con **`StreamScannerIngress`**. |
| 78 | SC-085-* en 12b al cerrar slice 85. |

## 16. Riesgos

| # | Respuesta |
|---|-----------|
| 79 | Pantalla escaneo incluye **búsqueda por nombre** auxiliar. |
| 80 | Auditoría: eventos bajo **INVENTARIO** / **VENTAS** existentes. |
| 81 | Cambio: precio **vigente catálogo** para SKU nuevo; crédito al **precio línea original**. |

---

## Cierre Gate R4-A

| Criterio | Estado |
|----------|--------|
| Respuestas documentadas | ✅ este archivo |
| DEC-052…055 | ✅ |
| RF-094…097 borrador | ✅ doc 04 |
| API-004 scan-sessions borrador | ✅ doc 07 |
| Tabla SLICE-85…94 en doc 10/21 | ✅ |
| SLICE-85 contrato + tests | ✅ código |

Próximo: **SLICE-86** confirmación ingreso a stock.