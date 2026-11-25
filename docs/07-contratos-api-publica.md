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
  "changeClp": 0
}
```

`sellerCode`: obligatorio en plantilla Atria POS (RF-084, colaborador activo en planilla).

Métodos: `EFECTIVO`, `OTRO`.

**Response 201 (SLICE-3)**

```json
{
  "saleId": "sale_01",
  "totalClp": 1000,
  "sellerCode": "V01",
  "dteStatus": "EMITIDA",
  "folio": 1001,
  "pdfUrl": null
}
```

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

- Checkout exige `sellerCode` de colaborador activo; ausente/inactivo → `VALIDACION`.
- Tests `SC-084-01`…`06` en `seller_code_checkout_test.dart`, `confirm_checkout_test.dart`.

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

### `POST /v0/stores/{storeId}/sales/{saleId}/void`

**Response 200**

```json
{ "saleId": "sale_01", "status": "ANULADA" }
```

**Tests comportamiento (SC-032-*)**

- Supervisor/dueño, turno abierto, DTE no emitida → `200`, stock revertido.
- Cajero → `403` `PERMISO_DENEGADO`.
- Venta ya anulada → `409` `CONFLICTO`.
- `dteStatus` `EMITIDA` → `400` `VALIDACION`.
- Sin turno abierto → `403` `TURNO_CERRADO`.

Estados `status` venta: `CONFIRMADA` | `ANULADA`.

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

### `POST /v0/stores/{storeId}/scan-sessions/{sessionId}/cancel`

**Response 200** — `state`: `cancelled`.

Confirmación a stock (`receiptScan`) y conteo → `CloseInventory`: **SLICE-86+** (no parte de SLICE-85).

**Tests comportamiento (SLICE-85)**

- Crear `receiptScan` válido → 201.
- `countScan` sin guía → 201.
- Bip producto → 200, quantity +1.
- Segundo bip mismo código &lt; 400 ms → quantity sin cambio adicional.
- Código desconocido → 404.
- Cajero → 403.
- Cancel → 200.

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

Validación: lista vacía, `countedQty` negativo, producto duplicado o inexistente, stock final &lt; 0 → 400.

`InventoryService.getInventoryClosePreview` / `submitInventoryClose`.

**Tests:** SC-088-01…08.

**SLICE-74 (UI RF-088):** `InventoryCloseScreen` en menú Operación; tests `SC-088-UI-01`…`04` en `inventory_close_ui_e2e_test.dart`, `inventory_close_menu_cajero_ui_test.dart`. `PosComposition` cablea `shiftRepository`, `saleRepository` e `inventoryCloseRepository` en `InventoryService`.

---

## API-005 — Cola DTE

### `POST /v0/stores/{storeId}/dte-queue/retry`

Reintenta pendientes. Response: `{ "processed": 2, "failed": 0 }`.

### `GET /v0/stores/{storeId}/dte-queue`

Lista pendientes para UI supervisor.

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
    "sellerCodeCheckout",
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

**Matriz 403 (RF-081):** reportes → `consultarReportes`; auditoría → `consultarAuditoria`; certificado → `consultarCertificado`; ventas del turno → `listarVentasTurno`; anular → `anularVenta`.

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

## Matriz RF ↔ API

| RF | Endpoints |
|----|-----------|
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