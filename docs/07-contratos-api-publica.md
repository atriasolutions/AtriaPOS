# 07 — Contratos API pública

Superficie bajo **pruebas de comportamiento**. Convención REST interna (app → core vía servicios in-process en MVP; misma forma HTTP para tests de contrato futuros).

**Versión:** `v0` (pre-implementación).

## Errores estándar

```json
{
  "error": {
    "code": "STOCK_INSUFICIENTE",
    "message": "No hay stock suficiente para Coca-Cola 1.5L",
    "details": { "productId": "..." }
  }
}
```

Códigos reservados: `VALIDACION`, `NO_AUTORIZADO`, `NO_ENCONTRADO`, `CONFLICTO`, `DTE_NO_DISPONIBLE`, `TURNO_CERRADO`.

---

## API-001 — Productos

**UI (SLICE-13):** pantalla «Nuevo producto» llama `ProductService.createProduct` (mismo contrato).

### `POST /v0/stores/{storeId}/products`

Crea producto en tienda.

**Request**

```json
{
  "name": "Pan hallulla",
  "salePriceClp": 500,
  "costClp": 300,
  "barcode": "7801234567890",
  "initialStock": 20,
  "blockWhenOutOfStock": true
}
```

**Response 201**

```json
{
  "id": "prod_01",
  "name": "Pan hallulla",
  "salePriceClp": 500,
  "stock": 20
}
```

**Tests comportamiento**

- Crear producto válido → 201 y stock inicial.
- Precio ≤ 0 → `VALIDACION`.
- Barcode duplicado con política estricta → `CONFLICTO`.

---

### `GET /v0/stores/{storeId}/products/search?q=`

**Response 200**

```json
{
  "items": [
    { "id": "prod_01", "name": "Pan hallulla", "salePriceClp": 500, "stock": 18 }
  ]
}
```

---

### `GET /v0/stores/{storeId}/products` (RF-091, SLICE-79)

Lista catálogo de la tienda con stock (solo lectura).

**Response 200**

```json
{
  "items": [
    {
      "id": "prod_01",
      "name": "Pan hallulla",
      "salePriceClp": 500,
      "stock": 18,
      "qrPayload": "atria://..."
    }
  ]
}
```

**Errores:** `PERMISO_DENEGADO` (403), `SESION_EXPIRADA` (401).

---

## API-002 — Carro y venta

### SLICE-3 (sin DTE ni turno)

#### `POST /v0/stores/{storeId}/carts`

**Response 201**

```json
{ "cartId": "cart_01" }
```

#### `GET /v0/stores/{storeId}/carts/{cartId}`

```json
{
  "cartId": "cart_01",
  "lines": [
    {
      "lineId": "line_01",
      "productId": "prod_01",
      "name": "Pan hallulla",
      "quantity": 2,
      "unitPriceClp": 500
    }
  ],
  "totalClp": 1000
}
```

#### `POST /v0/stores/{storeId}/carts/{cartId}/lines`

```json
{ "productId": "prod_01", "quantity": 2 }
```

#### `PATCH /v0/stores/{storeId}/carts/{cartId}/lines/{lineId}`

```json
{ "quantity": 1 }
```

#### `DELETE /v0/stores/{storeId}/carts/{cartId}/lines/{lineId}`

**Response 204**

#### `POST /v0/stores/{storeId}/carts/{cartId}/checkout`

```json
{
  "sellerCode": "V01",
  "payments": [
    { "method": "EFECTIVO", "amountClp": 1000 }
  ],
  "changeClp": 0,
  "documentType": "BOLETA",
  "invoiceReceiver": null
}
```

Boleta (default): omitir `documentType` o `BOLETA`; no enviar `invoiceReceiver`.

Factura (SLICE-93, RF-097, plantilla con `invoiceCheckout`):

```json
{
  "sellerCode": "V01",
  "payments": [{ "method": "EFECTIVO", "amountClp": 1000 }],
  "changeClp": 0,
  "documentType": "FACTURA",
  "invoiceReceiver": {
    "rut": "12.345.678-5",
    "businessName": "Cliente SpA",
    "giro": "Abarrotes",
    "email": "cliente@correo.cl",
    "address": "Av. 1 100",
    "city": "Santiago",
    "commune": "Nunoa",
    "phone": "912345678"
  }
}
```

`sellerCode`: obligatorio en plantilla Atria POS (RF-084, colaborador activo en planilla).

Métodos: `EFECTIVO`, `DEBITO`, `CREDITO`, `OTRO`. Débito y crédito registran el cobro; no mueven el efectivo esperado del turno (SLICE-145).

**Response 201 (SLICE-3)**

```json
{
  "saleId": "sale_01",
  "totalClp": 1000,
  "sellerCode": "V01",
  "dteStatus": "EMITIDA",
  "folio": 1001,
  "pdfUrl": null,
  "documentType": 39
}
```

**SLICE-93 (RF-097):** `documentType` en response es código SII (`39` boleta, `33` factura). Factura con RUT inválido o razón social vacía → `VALIDACION`. Plantilla sin factura → `VALIDACION`. Tests `SC-093-*` en `invoice_checkout_test.dart`, `invoice_checkout_api_test.dart`, `invoice_checkout_ui_e2e_test.dart`.

**SLICE-149–151:** el receptor exige RUT, razón social, giro, correo, dirección, ciudad, comuna y teléfono. Al confirmar, el POS guarda esos datos por RUT y los precarga en el siguiente cobro con factura.

**Tests comportamiento SLICE-3 (RF-030, RF-031 parcial)**

- Carro vacío checkout → `VALIDACION`.
- Stock 1, cantidad 2, bloqueo activo → `STOCK_INSUFICIENTE`.
- Pago &lt; total o `changeClp` inconsistente → `VALIDACION`.
- Checkout válido → stock descontado.

**SLICE-62 (RF-082)**

- `POST/GET` carro y `POST/PATCH/DELETE` líneas: sesión activa y `Permission.vender` (matriz RF-081 / plantilla Atria POS: cajero, supervisor, dueño).
- Sin sesión → `401`; tests `SC-082-01`…`05` en `cart_auth_test.dart`.

**SLICE-71 (UI RF-082):** pantalla Vender usa `updateLine` y `removeLine` in-process; tests `SC-082-UI-01`…`03` en `cart_editable_ui_e2e_test.dart`.

**SLICE-64 (RF-084)**

- Con `sellerCodeCheckout` en la plantilla, checkout exige `sellerCode` de colaborador activo; ausente/inactivo → `VALIDACION`.
- **SLICE-144 (DEC-066):** Atria POS no incluye esa feature. `sellerCode` vacío confirma (201) y la venta queda sin código. Tests `SC-144-*`.

**SLICE-4**

- Sin turno abierto en tienda → `TURNO_CERRADO` en checkout (HTTP 403).

#### SLICE-5+ (DTE)

Response ampliada con `dteStatus`, `folio`, `pdfUrl`. Tests con `FakeDteGateway` y `PENDIENTE_DTE` (Gate 1, opción A).

Estados `dteStatus`: `EMITIDA` | `PENDIENTE_DTE` | `RECHAZADA_SII`.

#### SLICE-10 (RF-032)

### `GET /v0/stores/{storeId}/shifts/open/sales` (SLICE-10 UI)

Solo supervisor/dueño. Requiere turno abierto.

**Response 200**

```json
{
  "items": [
    {
      "saleId": "sale_01",
      "totalClp": 1000,
      "status": "CONFIRMADA",
      "dteStatus": "EMITIDA",
      "folio": 1001
    }
  ]
}
```

### `POST /v0/stores/{storeId}/sales/{saleId}/credit-notes` (RF-096, SLICE-92)

Requiere `anularVenta` y venta con `dteStatus` **EMITIDA** del turno abierto.

```json
{
  "lines": [
    { "productId": "prod_01", "quantity": 1 }
  ]
}
```

`lines` vacío = NC total (anula fiscalmente la venta al completar todo el stock acreditado).

**201:** `creditNoteId`, `folio`, `dteStatus`, `creditedClp`, `saleStatus`, `returnedLines[]`.

Errores: `403`, `404`, `400`, `409` (exceso / sin unidades).

- `SaleService.issueCreditNote`.
- Tests: SC-092-* en `issue_credit_note_test.dart`, `credit_note_api_test.dart`.

### `POST /v0/stores/{storeId}/sales/{saleId}/void`

**Response 200**

```json
{ "saleId": "sale_01", "status": "ANULADA" }
```

**Tests comportamiento (SC-032-*)**

- Supervisor/dueño, turno abierto, DTE no emitida → `200`, stock revertido.
- Cajero → `403` `PERMISO_DENEGADO`.
- Venta ya anulada → `409` `CONFLICTO`.
- `dteStatus` `EMITIDA` → `400` `VALIDACION` (usar `credit-notes`).
- Sin turno abierto → `403` `TURNO_CERRADO`.

Estados `status` venta: `CONFIRMADA` | `ANULADA`.

### `GET /v0/stores/{storeId}/sales/{saleId}/product-exchange-context` (RF-095, SLICE-91)

Requiere `cambiarProducto`. Venta del turno abierto, no anulada.

**Response 200**

```json
{
  "saleId": "sale_01",
  "dteStatus": "PENDIENTE_DTE",
  "status": "CONFIRMADA",
  "lines": [
    {
      "productId": "prod_01",
      "productName": "Pan",
      "quantity": 2,
      "unitPriceClp": 500,
      "returnedQuantity": 0,
      "availableQuantity": 2
    }
  ]
}
```

Errores: `403`, `404`, `400` turno cerrado / venta anulada / otra validación.

- `SaleService.getSaleProductExchangeContext`.
- Tests: SC-091-01… en `get_sale_product_exchange_context_test.dart`, `sale_product_exchange_context_api_test.dart`.

### `POST /v0/stores/{storeId}/sales/{saleId}/product-exchanges` (RF-095, SLICE-90)

Requiere `cambiarProducto` y **turno abierto** (venta del turno actual).

```json
{
  "returnProductId": "prod_01",
  "returnQuantity": 1,
  "newProductId": "prod_02",
  "newQuantity": 1,
  "differencePayment": { "method": "EFECTIVO", "amountClp": 200 },
  "creditNoteId": "nc_01"
}
```

`differencePayment` obligatorio si `differenceClp ≠ 0` (cargo o devolución); omitir si cero.
`creditNoteId` obligatorio si la venta original tiene `dteStatus` **EMITIDA** (SLICE-92).

**Response 201**

```json
{
  "exchangeId": "ex_01",
  "newSaleId": "sale_02",
  "creditClp": 500,
  "chargeClp": 700,
  "differenceClp": 200,
  "returnProductStock": 4,
  "newProductStock": 9
}
```

- Crédito al **precio de línea original**; cargo al **precio vigente** del producto nuevo.
- Ajusta stock (`CAMBIO_DEVOLUCION` / `CAMBIO_ENTREGA`) y persiste `ProductExchange`.
- Cambios **parciales** por `productId` hasta agotar cantidad vendida.
- `dteStatus` `EMITIDA` en venta original → `400` (NC en SLICE-92).
- Sin unidades disponibles → `409` `CONFLICTO`.
- Stock insuficiente producto nuevo → `409`.
- `SaleService.registerProductExchange`.

**Tests:** SC-090-01…08 en `register_product_exchange_test.dart`, `product_exchange_api_test.dart`.

---

## API-003 — Turno y cierre

### `POST /v0/stores/{storeId}/shifts/open`

```json
{ "openingCashClp": 50000 }
```

**Response 201**

```json
{
  "shiftId": "shift_01",
  "openingCashClp": 50000,
  "openedAt": "2026-03-18T15:00:00.000Z"
}
```

Turno ya abierto en tienda → `CONFLICTO`.

---

### `GET /v0/stores/{storeId}/shifts/open` (opcional SLICE-4)

**Response 200**

```json
{ "shiftId": "shift_01", "openingCashClp": 50000, "openedAt": "..." }
```

Sin turno → `NO_ENCONTRADO`.

---

### `POST /v0/stores/{storeId}/shifts/{shiftId}/close`

```json
{ "countedCashClp": 150000 }
```

**Response 200**

```json
{
  "expectedCashClp": 148500,
  "countedCashClp": 150000,
  "differenceClp": 1500,
  "salesTotalClp": 98500,
  "openedAt": "2026-03-18T12:00:00.000Z",
  "closedAt": "2026-03-18T21:00:00.000Z"
}
```

**Tests comportamiento (RF-040, RF-041)**

- Abrir turno válido → 201.
- Segundo open → `CONFLICTO`.
- Cierre con ventas EFECTIVO → reporte coherente.
- Cerrar turno inexistente/cerrado → `NO_ENCONTRADO` o `VALIDACION`.
- Ver API-002: checkout sin turno → `TURNO_CERRADO`.

---

## API-004 — Inventario

### `GET /v0/stores/{storeId}/products/{productId}/stock`

**Response 200**

```json
{
  "productId": "prod_01",
  "stock": 20
}
```

Producto inexistente → `NO_ENCONTRADO`.

---

### `POST /v0/stores/{storeId}/products/{productId}/adjustments`

```json
{
  "delta": -3,
  "reason": "MERMA",
  "note": "Vencimiento"
}
```

Motivos permitidos: `MERMA`, `AJUSTE`, `CORRECCION` (`RECEPCION` reservado al ingreso con guía/lote, SLICE-65).

**Response 200**

```json
{
  "productId": "prod_01",
  "stock": 17,
  "movementId": "mov_01"
}
```

**Tests comportamiento**

- Consulta stock producto válido → 200.
- Producto desconocido → `NO_ENCONTRADO`.
- Ajuste merma válido → 200, stock actualizado y `movementId`.
- Ajuste dejaría stock &lt; 0 → `VALIDACION`.
- `delta` 0 o motivo inválido → `VALIDACION`.
- Motivo `RECEPCION` en adjustments → `VALIDACION` (usar stock-receipts).

---

### `POST /v0/stores/{storeId}/products/{productId}/stock-receipts` (RF-085)

Requiere sesión con `ajustarInventario` (supervisor/dueño). Solo producto existente.

```json
{
  "quantity": 10,
  "guideRef": "GD-12345",
  "lotRef": "L-202601"
}
```

**Response 200**

```json
{
  "productId": "prod_01",
  "stock": 30,
  "movementId": "mov_01",
  "guideRef": "GD-12345",
  "lotRef": "L-202601"
}
```

Referencia guía/lote: 1–32 caracteres, `A–Z`, `0–9`, `-`, `_`, sin `ñ`.

**Tests comportamiento**

- Ingreso válido → 200, stock incrementa, movimiento `RECEPCION` con refs.
- Producto desconocido → `NO_ENCONTRADO`.
- Cantidad ≤ 0 o refs inválidas → `VALIDACION`.
- Cajero → 403.

**SLICE-73 (UI RF-085):** `StockReceiptScreen` en menú Operación; tests `SC-085-UI-01`…`03` en `stock_receipt_ui_e2e_test.dart`, `stock_menu_cajero_ui_test.dart`.

**SLICE-87 (UI escaneo RF-085):** pestañas Manual / Por escaneo en `StockReceiptScreen`; `scanSessionService` + `ScannerIngress`; tests `SC-087-UI-*` en `stock_receipt_scan_ui_e2e_test.dart`.

---

### `POST /v0/stores/{storeId}/scan-sessions` (RF-094, SLICE-85)

Requiere `ajustarInventario`.

```json
{
  "kind": "receiptScan",
  "guideRef": "GD-12345",
  "lotRef": "L-202601"
}
```

`kind`: `receiptScan` | `countScan`. Para `receiptScan`, `guideRef` y `lotRef` obligatorios.

**Response 201**

```json
{
  "sessionId": "scan_01",
  "kind": "receiptScan",
  "state": "draft",
  "guideRef": "GD-12345",
  "lotRef": "L-202601",
  "lines": []
}
```

---

### `GET /v0/stores/{storeId}/scan-sessions/{sessionId}`

**Response 200** — misma forma que creación con `lines[]`:

```json
{
  "lines": [
    {
      "productId": "prod_01",
      "productName": "Pan",
      "quantity": 3,
      "lastScannedAt": "2026-11-25T12:00:00Z"
    }
  ]
}
```

---

### `POST /v0/stores/{storeId}/scan-sessions/{sessionId}/scans`

```json
{
  "code": "7801234567890"
}
```

Resuelve barcode o QR (`parseProductIdFromScan`). **200** devuelve sesión actualizada. Producto desconocido → `NO_ENCONTRADO`. Sesión no `draft` → `VALIDACION`.

---

### `POST /v0/stores/{storeId}/scan-sessions/{sessionId}/confirm` (RF-085, SLICE-86)

Solo `receiptScan` en `draft` con líneas. Body opcional:

```json
{ "idempotencyKey": "uuid-opcional" }
```

**Response 200**

```json
{
  "sessionId": "scan_01",
  "state": "confirmed",
  "guideRef": "GD-1",
  "lotRef": "L-1",
  "results": [
    {
      "productId": "prod_01",
      "quantity": 3,
      "stock": 13,
      "movementId": "mov_01"
    }
  ]
}
```

- Vacío / `countScan` / cancelada → `VALIDACION` (400).
- Ya confirmada sin clave idempotente → `CONFLICTO` (409).
- Misma `idempotencyKey` → 200 idempotente.
- Segundo `recordStockReceipt` por línea vía `RecordStockReceipt`.

### `POST /v0/stores/{storeId}/scan-sessions/{sessionId}/confirm-count` (RF-088, SLICE-88)

Solo `countScan` en `draft` con líneas. Requiere **turno abierto** (misma regla que `CloseInventory`). Body opcional:

```json
{ "idempotencyKey": "uuid-opcional" }
```

**Response 200**

```json
{
  "sessionId": "scan_01",
  "state": "confirmed",
  "closeId": "ic_01",
  "shiftId": "sh_01",
  "closedAt": "2026-01-01T12:00:00.000Z",
  "lines": [
    {
      "productId": "prod_01",
      "systemStock": 12,
      "countedStock": 9,
      "variance": -3,
      "unitsSoldInShift": 0
    }
  ]
}
```

- Solo entran al cierre los **SKU escaneados** en la sesión (conteo parcial v1).
- Vacío / `receiptScan` / cancelada → `VALIDACION` (400).
- Sin turno abierto → `NO_ENCONTRADO` (404).
- Ya confirmada sin clave idempotente → `CONFLICTO` (409).
- Misma `idempotencyKey` → 200 idempotente.
- Delega en `CloseInventory` (`ScanSessionService.confirmInventoryCountScan`).

### `POST /v0/stores/{storeId}/scan-sessions/{sessionId}/cancel`

**Response 200** — `state`: `cancelled`.

**Tests comportamiento (SLICE-85)**

- Crear `receiptScan` válido → 201.
- `countScan` sin guía → 201.
- Bip producto → 200, quantity +1.
- Segundo bip mismo código &lt; 400 ms → quantity sin cambio adicional.
- Código desconocido → 404.
- Cajero → 403.
- Cancel → 200.

**Tests comportamiento (SLICE-86)**

- Confirm ingreso multi-SKU → 200, stocks y movimientos RECEPCION.
- Sin líneas → 400.
- `countScan` confirm → 400.
- Doble confirm → 409; idempotency → 200.
- Cajero → 403.

**Tests comportamiento (SLICE-88)**

- `SC-088-SCAN-01`…`08` en `packages/core/test/api/scan_session_count_confirm_test.dart`.

---

### `GET /v0/stores/{storeId}/inventory-close/preview` (RF-088)

Requiere `ajustarInventario` y **turno abierto**. **200**:

```json
{
  "shiftId": "sh_01",
  "items": [
    {
      "productId": "prod_01",
      "name": "Pan",
      "systemStock": 12,
      "unitsSoldInShift": 3
    }
  ]
}
```

Sin turno → 404. Cajero → 403.

### `POST /v0/stores/{storeId}/inventory-closes` (RF-088)

```json
{
  "lines": [{ "productId": "prod_01", "countedQty": 9 }]
}
```

**201** — `closeId`, `shiftId`, `closedAt`, `lines[]` con `systemStock`, `countedStock`, `variance`, `unitsSoldInShift`.

Validación: lista vacía, `countedQty` negativo, producto duplicado o inexistente, stock final &lt; 0 → 400. **SLICE-153:** debe incluir un recuento por cada producto del catálogo de la tienda; si falta alguno → 400 `Complete el conteo de todos los productos`.

`InventoryService.getInventoryClosePreview` / `submitInventoryClose`.

**Tests:** SC-088-01…08.

**SLICE-74 (UI RF-088):** `InventoryCloseScreen` en menú Operación; tests `SC-088-UI-01`…`04` en `inventory_close_ui_e2e_test.dart`, `inventory_close_menu_cajero_ui_test.dart`. `PosComposition` cablea `shiftRepository`, `saleRepository` e `inventoryCloseRepository` en `InventoryService`.

**SLICE-89 (UI escaneo RF-088):** pestañas Manual / Por escaneo en `InventoryCloseScreen`; `confirmInventoryCountScan` + `ScannerIngress`; `ScanSessionService` comparte repos Drift con `InventoryService`; tests `SC-088-SCAN-UI-*` en `inventory_close_scan_ui_e2e_test.dart`.

---

## API-005 — Cola DTE

### `POST /v0/stores/{storeId}/dte-queue/retry`

Reintenta pendientes. Response: `{ "processed": 2, "failed": 0 }`.

### `GET /v0/stores/{storeId}/dte-queue`

Lista pendientes para UI supervisor. Ítems incluyen `documentType` (39 boleta, 61 NC) y `documentId` (SLICE-92).

Consulta de certificado: ver **API-010**.

---

## API-007 — Tienda (RF-001)

### `POST /v0/stores/bootstrap`

Solo si no existe tienda en el dispositivo (MVP una tienda).

```json
{
  "rut": "12.345.678-5",
  "legalName": "Minimarket La Esquina",
  "businessLine": "Almacén",
  "ownerFirstName": "Dueño",
  "ownerLastName": "Tienda",
  "ownerUsername": "jperez",
  "ownerRut": "12.345.678-5",
  "ownerPin": "2468"
}
```

**Response 201**

```json
{
  "storeId": "uuid",
  "userId": "uuid-dueno",
  "token": "local-session",
  "role": "DUENO",
  "expiresAt": "..."
}
```

Errores: RUT u datos inválidos → `VALIDACION` (400). Tienda ya existe → `CONFLICTO` (409).

### `GET /v0/stores/active`

**Response 200**

```json
{
  "storeId": "uuid",
  "rut": "12.345.678-5",
  "legalName": "Minimarket La Esquina",
  "businessLine": "Almacén",
  "taxConfig": { "defaultTaxTreatment": "AFECTO" }
}
```

Sin tienda → `NO_ENCONTRADO` (404).

**Tests comportamiento (SC-001-01…03)**

### `GET /v0/stores/{storeId}/pos-template` (RF-089)

**Response 200**

```json
{
  "templateId": "ATRIA_POS",
  "displayName": "Atria POS",
  "features": [
    "auditTrail",
    "closeShift",
    "collaboratorPlanilla",
    "dailySalesReport",
    "dteQueue",
    "fiscalCertificate",
    "inventoryClose",
    "productCreate",
    "shiftSalesList",
    "stockAdjust",
    "stockInsights",
    "stockReceiptGuiaLote",
    "userManagement"
  ]
}
```

Tienda inexistente → `NO_ENCONTRADO` (404).

**Tests comportamiento (SC-089-02)**

---

## API-006 — Autenticación (MVP local)

### `POST /v0/auth/login`

```json
{ "username": "usr_cajero", "pin": "****" }
```

**Response 200**

```json
{ "token": "local-session", "role": "CAJERO", "expiresAt": "..." }
```

Errores: `CREDENCIAL_INVALIDA` (401). Operaciones privilegiadas sin sesión o rol: `PERMISO_DENEGADO` (403). Sesión vencida: `SESION_EXPIRADA` (401).

### `POST /v0/stores/{storeId}/auth/end-session` (RF-093, SLICE-82)

Cierra sesión local. Precondición: **sin turno abierto** (DEC-050).

**Response 204** sin cuerpo.

**Errores:** `VALIDACION` (400) si hay turno abierto («Cierre la caja antes de cambiar de usuario»); `SESION_EXPIRADA` (401).

**Tests SLICE-7 / SLICE-61 (SC-070-01…04, SC-081-xx):** login válido; PIN malo; matriz RF-081 (`RoleCapabilities`); cajero bloqueado en reportes/ajuste/cierre; dueño crea usuario.

**Matriz 403 (RF-081):** reportes → `consultarReportes`; auditoría → `consultarAuditoria`; certificado → `consultarCertificado`; ventas del turno → `listarVentasTurno`; anular → `anularVenta`; cambio producto → `cambiarProducto`.

### `createUser` (in-process, SLICE-60 / RF-080)

Solo rol **DUENO** (`Permission.gestionarUsuarios`).

**Request**

```json
{
  "username": "cajero2",
  "firstName": "Nombre",
  "lastName": "Apellido",
  "rut": "12.345.678-5",
  "role": "CAJERO",
  "pin": "1234"
}
```

`username` y `pin` sin letra ñ. `role`: `CAJERO` | `SUPERVISOR` (no crear `DUENO` desde UI).

**Response 201**

```json
{
  "id": "uuid",
  "username": "cajero2",
  "firstName": "Nombre",
  "lastName": "Apellido",
  "rut": "12.345.678-5",
  "role": "CAJERO",
  "displayName": "Nombre Apellido"
}
```

Errores: `PERMISO_DENEGADO` (403), `VALIDACION` (400, PIN &lt; 4 / credenciales / RUT), `CONFLICTO` (409, `username` duplicado).

### `listUsers` (in-process, SLICE-70 / RF-080)

Solo **DUENO** (`Permission.gestionarUsuarios`).

**Response 200**

```json
[
  {
    "id": "uuid",
    "username": "usr_cajero",
    "firstName": "Cajero",
    "lastName": "Demo",
    "rut": "12.345.678-5",
    "role": "CAJERO",
    "displayName": "Cajero Demo"
  }
]
```

Errores: `PERMISO_DENEGADO` (403).

### `updateUser` (in-process, SLICE-70 / RF-080)

**Request**

```json
{
  "firstName": "Nombre",
  "lastName": "Apellido",
  "rut": "12.345.678-5",
  "role": "SUPERVISOR",
  "newPin": "4321"
}
```

`newPin` opcional (vacío = no cambiar). No cambiar `username`. No asignar rol `DUENO` ni cambiar rol del dueño existente.

**Response 200** — mismo cuerpo que `createUser` (201).

Errores: `PERMISO_DENEGADO` (403), `VALIDACION` (400), `NO_ENCONTRADO` (404).

**Tests comportamiento (SC-080-07…13, SC-080-UI-01…04)**

---

## API-008 — Reportes (RF-060)

### `GET /v0/stores/{storeId}/reports/daily`

Query opcional: `date=YYYY-MM-DD` (día calendario local; default hoy).

**Response 200**

```json
{
  "date": "2026-03-18",
  "salesTotalClp": 2500,
  "transactionCount": 2,
  "averageTicketClp": 1250
}
```

Solo supervisor y dueño (403 cajero). Ventas `ANULADA` no cuentan.

**Tests:** SC-060-02 (core/API).

### `GET /v0/stores/{storeId}/reports/stock-insights` (RF-087)

Query: `asOf=YYYY-MM-DD` (default hoy local), `limit` entero (default 10, máx. 50).

**Response 200**

```json
{
  "asOfDate": "2026-03-18",
  "periodDays": 30,
  "defaultLowStockThreshold": 5,
  "lowStock": [
    {
      "productId": "p1",
      "name": "Pan",
      "stock": 2,
      "lowStockThreshold": 5,
      "salePriceClp": 500
    }
  ],
  "topSellers": [
    { "productId": "p1", "name": "Pan", "unitsSold": 120 }
  ]
}
```

`lowStockThreshold` en cada ítem es el umbral **efectivo** (resuelto).

Solo supervisor y dueño (403 cajero). Ventas `ANULADA` no cuentan en `topSellers`.

`ReportService.getStockInsights` (in-process).

**Tests:** SC-087-01…08 (core/API/adapters).

**SLICE-73 (UI RF-087):** `StockInsightsScreen` en menú Operación; tests `SC-087-UI-01`…`03` en `stock_insights_ui_e2e_test.dart`, `stock_menu_cajero_ui_test.dart`.

---

## API-009 — Auditoría (RF-070, RF-086)

### `GET /v0/stores/{storeId}/reports/audit-trail`

Query (calendario local):

- `date=YYYY-MM-DD` — legacy RF-070 (un día; equivalente a `from=to=date`).
- `from`, `to` — rango **inclusive** ambos extremos (máx. 31 días).
- `categories` — CSV opcional: `VENTAS`, `INVENTARIO`, `USUARIOS`, `PAGOS` (omitir = todas; `PAGOS` devuelve lista vacía en MVP).

Si no se indica fecha, default **hoy**.

**Response 200**

```json
{
  "date": "2026-03-18",
  "fromDate": "2026-03-01",
  "toDate": "2026-03-07",
  "items": [
    {
      "occurredAt": "2026-03-18T13:00:00.000Z",
      "category": "VENTAS",
      "type": "CONFIRMA_VENTA",
      "actorUserId": "usr_supervisor",
      "summary": "Venta confirmada: $500",
      "refId": "sal_..."
    },
    {
      "occurredAt": "2026-03-18T14:00:00.000Z",
      "category": "INVENTARIO",
      "type": "AJUSTE_STOCK",
      "actorUserId": "usr_supervisor",
      "summary": "MERMA · Pan (-1)",
      "refId": "mov_..."
    }
  ]
}
```

`date` se repite solo cuando `fromDate == toDate` (compat SC-070). Tipos nuevos: `ANULA_VENTA` (por `voidedAt`), `CREA_USUARIO` (alta POS).

Solo supervisor y dueño (403 cajero). `CONFIRMA_VENTA` excluye ventas ya anuladas; la anulación aparece como `ANULA_VENTA`. Movimientos motivo `VENTA` se excluyen del inventario.

Rango inválido (`to` &lt; `from`, &gt; 31 días, fecha mal formada) → **400** `VALIDACION`.

`ReportService.getAuditTrail` (in-process): parámetros `date`, `from`, `to`, `categories`.

**Tests:** SC-070-01, SC-086-01…08 (core/API/adapters).

**SLICE-74 (UI RF-086):** `AuditTrailScreen` con rango y filtros; ítem menú Operación sigue visible con permiso `anularVenta` (comportamiento heredado SLICE-20). Tests `SC-086-UI-01`…`03` en `audit_trail_range_ui_e2e_test.dart`; regresión `SC-070-UI-01/02` en `audit_trail_ui_e2e_test.dart`.

---

## API-010 — Certificado fiscal (RF-003)

### `GET /v0/stores/{storeId}/fiscal/certificate`

Solo supervisor y dueño (403 cajero).

**Response 200**

```json
{
  "status": "VALIDO",
  "subject": "CN=Emisor Demo",
  "validFrom": "2025-01-01T00:00:00.000Z",
  "validTo": "2026-12-31T23:59:59.000Z"
}
```

`status`: `VALIDO` | `VENCIDO` | `NO_CONFIGURADO` (sin certificado en dispositivo).

`FiscalService.getCertificate` (in-process). No expone PEM ni rutas de archivo.

**Tests:** SC-003-01 (core/API).

---

## API-011 — Planilla colaboradores (RF-083)

Solo **dueño** (`Permission.gestionarPlanilla`). Colaborador ≠ usuario POS (DEC-049).

### `POST /v0/stores/{storeId}/collaborators`

```json
{
  "sellerCode": "V01",
  "firstName": "Colab",
  "lastName": "Uno"
}
```

**Response 201** — `CollaboratorResponse` con `id`, `sellerCode`, `firstName`, `lastName`, `active`.

### `GET /v0/stores/{storeId}/collaborators`

**Response 200** — lista con campo `active` (administración).

### `GET /v0/stores/{storeId}/collaborators/active`

Roles con `Permission.vender` (cajero, supervisor, dueño). Solo colaboradores `active: true` para selección en checkout (SLICE-72 UI).

In-process: `CollaboratorService.listActiveForSale` consumido por `checkout_panel.dart`. Tests UI `SC-084-UI-01`…`03` en `seller_code_checkout_ui_e2e_test.dart`.

### `PATCH /v0/stores/{storeId}/collaborators/{id}`

Campos opcionales: `sellerCode`, `firstName`, `lastName`, `active`.

### `DELETE /v0/stores/{storeId}/collaborators/{id}`

**Response 200** — desactiva (`active: false`); no borra fila.

**Tests:** SC-083-01…06 (`collaborator_service_test`, `collaborator_auth_test`).

---

### Companion LAN (RF-098, SLICE-96+)

Servidor embebido en `pos_app`; **HTTPS** en producción (DEC-059, SLICE-109), puerto **8765**; prefijo API `/v0/`.

#### `POST /v0/stores/{storeId}/companion/pair`

```json
{
  "pairingCode": "A7K9M2",
  "mode": "VENDER"
}
```

`mode`: `VENDER` | `RECEIPT_SCAN` | `COUNT_SCAN`.

**Response 200**

```json
{
  "token": "tok_…",
  "expiresAt": "2026-11-25T12:30:00Z",
  "wsPath": "/v0/ws/companion"
}
```

Errores: código inválido/expirado → `VALIDACION`; modo distinto al ofrecido → `VALIDACION`.

#### `GET /companion/atria-ca.pem` (SLICE-109)

Certificado para confianza en el celular (`application/x-pem-file`).

#### `GET /companion/instalar-certificado`

HTML breve en español con enlace al PEM.

#### `WebSocket /v0/ws/companion?token=…`

En HTTPS el cliente usa **wss**.

Cliente → servidor:

```json
{ "type": "scan", "code": "7801234567890" }
{ "type": "heartbeat" }
```

Servidor → cliente (tras escaneo aceptado, SLICE-160):

```json
{ "type": "scan", "accepted": true, "code": "7801234567890", "productName": "Pan hallulla" }
```

`productName` es opcional (producto no resuelto o código no catalogado).

#### `GET /c/{pairingCode}` (SLICE-107, DEC-060)

Resuelve el código de emparejamiento y redirige a la PWA.

**Response 302** — `Location: /companion/?storeId=…&mode=…&pairingCode=…`

Oferta inexistente o expirada → **404** (texto breve en español).

#### QR en POS (payload, no endpoint)

`https://{host}:{port}/c/A7K9M2` (enlace corto; el celular sigue el redirect a `/companion/?…`).

**Tests:** `SC-096-*`, `SC-107-*`, `companion_lan_server_test.dart`, e2e SLICE-99–101.

#### PWA `/companion/` (SLICE-108, SLICE-110, DEC-061)

Tras el redirect con query de emparejamiento: **auto-pair**, modo en español, sin UUID de tienda en pantalla. Con sesión activa: **visor de cámara opcional** (HTTPS) que envía el mismo mensaje WS `scan` que el ingreso manual; si la cámara falla, sin caja vacía — mensaje breve y campo manual obligatorio. Reintento de emparejamiento solo si falla la conexión.

Build obligatorio con `--base-href=/companion/` en `companion_web` (script `prepare-companion-pwa.ps1`). Sin `index.html` en la carpeta servida, el POS **no muestra QR** en HTTPS (SLICE-113, clave UI `companion_pwa_missing`).

**Tests:** `SC-108-*`, `SC-110-*` en `apps/companion_web/test/`; `SC-113-*`, `SC-114-*` en `pos_app`.

Al arrancar, el certificado servidor companion se emite para la IPv4 anunciada (misma que el QR). Instalación CA: UI `companion_ca_install_hint` → `GET /companion/instalar-certificado`.

#### Oferta de emparejamiento (in-process, POS)

`CompanionService.createPairingOffer(storeId, mode)` — genera código para QR; no expuesto como REST en slice 96.

#### Efecto en POS por modo (SLICE-112)

Mismo mensaje WS `scan` para los tres modos; la pantalla o sesión activa define el efecto:

| Modo pair | Efecto POS esperado |
|-----------|---------------------|
| `VENDER` | `productService.searchProducts` / carrito (pantalla Vender) |
| `RECEIPT_SCAN` | `scanSessionService.recordScan` en sesión ingreso |
| `COUNT_SCAN` | `scanSessionService.recordScan` en sesión conteo |

**Tests:** SC-112-* en `companion_lan_flow_e2e_test.dart`.

#### Estado celular LAN (SLICE-111, in-process POS)

- `CompanionService.getLanStatus(storeId)` → `CompanionLanStatus` con fases: `none`, `sessionOnly` (token sin WS), `live` (WebSocket abierto).
- `CompanionService.disconnectLan(storeId)` → revoca sesión y cierra sockets del token.
- UI POS: chip `companion_lan_status_chip`, botón `companion_disconnect_button` en diálogo QR.

**Tests:** SC-111-* en core, adapters y `companion_lan_e2e_test.dart`.

---

## Matriz RF ↔ API

| RF | Endpoints |
|----|-----------|
| RF-098 | Companion LAN (pair, WS, `GET /c/{code}`); estáticos `/companion/` |
| RF-010, RF-011 | API-001 |
| RF-030–032, RF-082, RF-084 | API-002 |
| RF-040–041 | API-003 |
| RF-020–021, RF-085, RF-088, RF-094 | API-004 |
| RF-051 | API-005 |
| RF-002 | API-006 |
| RF-001, RF-089 | API-007 |
| RF-060, RF-087 | API-008 |
| RF-070, RF-086 | API-009 |
| RF-003 | API-010 |
| RF-083 | API-011 |