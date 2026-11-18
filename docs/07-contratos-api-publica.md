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
  "payments": [
    { "method": "EFECTIVO", "amountClp": 1000 }
  ],
  "changeClp": 0
}
```

Métodos: `EFECTIVO`, `OTRO`.

**Response 201 (SLICE-3)**

```json
{
  "saleId": "sale_01",
  "totalClp": 1000,
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
{ "shiftId": "shift_01", "openingCashClp": 50000 }
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
  "salesTotalClp": 98500
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

Motivos permitidos: `MERMA`, `AJUSTE`, `RECEPCION`, `CORRECCION`.

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

---

## API-005 — Cola DTE

### `POST /v0/stores/{storeId}/dte-queue/retry`

Reintenta pendientes. Response: `{ "processed": 2, "failed": 0 }`.

### `GET /v0/stores/{storeId}/dte-queue`

Lista pendientes para UI supervisor.

### Estado certificado (opcional SLICE-8)

`GET /v0/stores/{storeId}/fiscal/certificate` — `VALIDO` | `VENCIDO` | `NO_CONFIGURADO` (implementación UI/API posterior; validación hoy en `DteGateway` replay).

---

## API-007 — Tienda (RF-001)

### `POST /v0/stores/bootstrap`

Solo si no existe tienda en el dispositivo (MVP una tienda).

```json
{
  "rut": "12.345.678-5",
  "legalName": "Minimarket La Esquina",
  "businessLine": "Almacén",
  "ownerDisplayName": "Dueño",
  "ownerPin": "2468"
}
```

**Response 201**

```json
{
  "storeId": "uuid",
  "userId": "usr_dueno",
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

---

## API-006 — Autenticación (MVP local)

### `POST /v0/auth/login`

```json
{ "userId": "usr_cajero", "pin": "****" }
```

**Response 200**

```json
{ "token": "local-session", "role": "CAJERO", "expiresAt": "..." }
```

Errores: `CREDENCIAL_INVALIDA` (401). Operaciones privilegiadas sin sesión o rol: `PERMISO_DENEGADO` (403). Sesión vencida: `SESION_EXPIRADA` (401).

**Tests SLICE-7 (SC-070-01…04):** login válido; PIN malo; cajero bloqueado en ajuste/cierre/catálogo; dueño crea usuario.

---

## Matriz RF ↔ API

| RF | Endpoints |
|----|-----------|
| RF-010, RF-011 | API-001 |
| RF-030–032 | API-002 |
| RF-040–041 | API-003 |
| RF-020–021 | API-004 |
| RF-051 | API-005 |
| RF-002 | API-006 |
| RF-001 | API-007 |