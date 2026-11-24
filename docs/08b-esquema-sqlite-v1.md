# 08b — Esquema SQLite v1 (productos SLICE-1)

**Estado:** Aprobado para tabla `products` (DEC-016, DEC-017).

## `products` (SLICE-1)

| Columna | Tipo | Notas |
|---------|------|-------|
| id | TEXT PK | UUID v4 |
| store_id | TEXT NOT NULL | |
| name | TEXT NOT NULL | |
| sale_price_clp | INTEGER NOT NULL | IVA incluido |
| cost_clp | INTEGER NULL | |
| barcode | TEXT NULL | |
| stock | INTEGER NOT NULL DEFAULT 0 | |
| block_when_out_of_stock | INTEGER NOT NULL DEFAULT 1 | 0/1 |

Índices:

- `idx_products_store_name` — búsqueda por nombre
- `idx_products_store_barcode` — UNIQUE `(store_id, barcode)` WHERE barcode IS NOT NULL (DEC-010)

## DDL referencia

```sql
CREATE TABLE products (
  id TEXT NOT NULL PRIMARY KEY,
  store_id TEXT NOT NULL,
  name TEXT NOT NULL,
  sale_price_clp INTEGER NOT NULL,
  cost_clp INTEGER,
  barcode TEXT,
  stock INTEGER NOT NULL DEFAULT 0,
  block_when_out_of_stock INTEGER NOT NULL DEFAULT 1
);

CREATE INDEX idx_products_store_name ON products(store_id, name);
CREATE UNIQUE INDEX idx_products_store_barcode ON products(store_id, barcode)
  WHERE barcode IS NOT NULL;
```

## `stock_movements` (SLICE-2)

| Columna | Tipo | Notas |
|---------|------|-------|
| id | TEXT PK | UUID v4 |
| store_id | TEXT NOT NULL | |
| product_id | TEXT NOT NULL | FK lógico a `products.id` |
| delta | INTEGER NOT NULL | Puede ser negativo (merma) |
| reason | TEXT NOT NULL | MERMA, AJUSTE, RECEPCION, CORRECCION |
| note | TEXT NULL | |
| actor_id | TEXT NULL | Rol supervisor en SLICE-7 |
| created_at | TEXT NOT NULL | ISO-8601 UTC |
| guide_ref | TEXT NULL | Guía ingreso RF-085 (SLICE-65) |
| lot_ref | TEXT NULL | Lote ingreso RF-085 (SLICE-65) |

Índice: `idx_stock_movements_product` ON `(store_id, product_id, created_at)`.

```sql
CREATE TABLE stock_movements (
  id TEXT NOT NULL PRIMARY KEY,
  store_id TEXT NOT NULL,
  product_id TEXT NOT NULL,
  delta INTEGER NOT NULL,
  reason TEXT NOT NULL,
  note TEXT,
  actor_id TEXT,
  created_at TEXT NOT NULL
);

CREATE INDEX idx_stock_movements_product
  ON stock_movements(store_id, product_id, created_at);
```

## Ventas (SLICE-3, borrador drift)

Tablas: `carts`, `cart_lines`, `sales`, `sale_lines`, `payments` (carritos abiertos opcionales en MVP in-memory).

```sql
CREATE TABLE sales (
  id TEXT NOT NULL PRIMARY KEY,
  store_id TEXT NOT NULL,
  cart_id TEXT NOT NULL,
  total_clp INTEGER NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE sale_lines (
  id TEXT NOT NULL PRIMARY KEY,
  sale_id TEXT NOT NULL,
  product_id TEXT NOT NULL,
  product_name TEXT NOT NULL,
  quantity INTEGER NOT NULL,
  unit_price_clp INTEGER NOT NULL
);

CREATE TABLE payments (
  id TEXT NOT NULL PRIMARY KEY,
  sale_id TEXT NOT NULL,
  method TEXT NOT NULL,
  amount_clp INTEGER NOT NULL
);
```

## `shifts` (SLICE-4)

| Columna | Tipo | Notas |
|---------|------|-------|
| id | TEXT PK | UUID |
| store_id | TEXT NOT NULL | |
| opening_cash_clp | INTEGER NOT NULL | |
| counted_cash_clp | INTEGER NULL | Al cierre |
| status | TEXT NOT NULL | ABIERTO / CERRADO |
| opened_at | TEXT NOT NULL | |
| closed_at | TEXT NULL | |

Columna `sales.shift_id` TEXT NOT NULL (SLICE-4).

```sql
CREATE TABLE shifts (
  id TEXT NOT NULL PRIMARY KEY,
  store_id TEXT NOT NULL,
  opening_cash_clp INTEGER NOT NULL,
  counted_cash_clp INTEGER,
  status TEXT NOT NULL,
  opened_at TEXT NOT NULL,
  closed_at TEXT
);
```

## `users` (SLICE-7)

| Columna | Tipo | Notas |
|---------|------|-------|
| id | TEXT PK | |
| store_id | TEXT NOT NULL | |
| role | TEXT NOT NULL | DUENO / SUPERVISOR / CAJERO |
| pin_hash | TEXT NOT NULL | bcrypt |
| display_name | TEXT NOT NULL | |

```sql
CREATE TABLE users (
  id TEXT NOT NULL PRIMARY KEY,
  store_id TEXT NOT NULL,
  role TEXT NOT NULL,
  pin_hash TEXT NOT NULL,
  display_name TEXT NOT NULL
);
```

## DTE (SLICE-5)

Columnas adicionales en `sales`:

| Columna | Tipo | Notas |
|---------|------|-------|
| status | TEXT NOT NULL DEFAULT 'CONFIRMADA' | CONFIRMADA / ANULADA (SLICE-10) |
| dte_status | TEXT NOT NULL DEFAULT 'PENDIENTE_DTE' | EMITIDA / PENDIENTE_DTE / RECHAZADA_SII |
| folio | INTEGER NULL | |
| pdf_url | TEXT NULL | |

Tabla `dte_queue`:

| Columna | Tipo | Notas |
|---------|------|-------|
| sale_id | TEXT PK | |
| store_id | TEXT NOT NULL | |
| attempts | INTEGER NOT NULL DEFAULT 0 | |
| last_error | TEXT NULL | |
| created_at | TEXT NOT NULL | |

```sql
ALTER TABLE sales ADD COLUMN status TEXT NOT NULL DEFAULT 'CONFIRMADA';
ALTER TABLE sales ADD COLUMN dte_status TEXT NOT NULL DEFAULT 'PENDIENTE_DTE';
ALTER TABLE sales ADD COLUMN folio INTEGER;
ALTER TABLE sales ADD COLUMN pdf_url TEXT;

CREATE TABLE dte_queue (
  sale_id TEXT NOT NULL PRIMARY KEY,
  store_id TEXT NOT NULL,
  attempts INTEGER NOT NULL DEFAULT 0,
  last_error TEXT,
  created_at TEXT NOT NULL
);
```

## `stores` (SLICE-12, schema v9)

| Columna | Tipo | Notas |
|---------|------|-------|
| id | TEXT PK | UUID v4 |
| rut | TEXT NOT NULL | display con puntos |
| legal_name | TEXT NOT NULL | |
| business_line | TEXT NOT NULL | giro |
| tax_config | TEXT NOT NULL | JSON mínimo |
| created_at | TEXT NOT NULL | ISO-8601 UTC |

```sql
CREATE TABLE stores (
  id TEXT NOT NULL PRIMARY KEY,
  rut TEXT NOT NULL,
  legal_name TEXT NOT NULL,
  business_line TEXT NOT NULL,
  tax_config TEXT NOT NULL,
  created_at TEXT NOT NULL
);
```

## DTE folios (SLICE-8 Fase B, schema v7)

Tabla `dte_folio_counters`:

| Columna | Tipo | Notas |
|---------|------|-------|
| store_id | TEXT PK (compuesto) | |
| document_type | INTEGER PK (compuesto) | ej. 39 |
| next_folio | INTEGER NOT NULL | siguiente a asignar |
| caf_desde | INTEGER NOT NULL | rango CAF |
| caf_hasta | INTEGER NOT NULL | rango CAF |

```sql
CREATE TABLE dte_folio_counters (
  store_id TEXT NOT NULL,
  document_type INTEGER NOT NULL,
  next_folio INTEGER NOT NULL,
  caf_desde INTEGER NOT NULL,
  caf_hasta INTEGER NOT NULL,
  PRIMARY KEY (store_id, document_type)
);
```

## Revisión 2 — `users` schema v13 (SLICE-60)

Columnas nuevas: `username`, `first_name`, `last_name`, `user_rut`. Índice único `(store_id, username)`. Migración desde v12: `username = id`, `first_name = display_name`.

## Revisión 2 — `collaborators` schema v14 (SLICE-63)

| Columna | Tipo | Notas |
|---------|------|-------|
| id | TEXT PK | UUID |
| store_id | TEXT NOT NULL | |
| seller_code | TEXT NOT NULL | mayúsculas A–Z, 0–9 |
| first_name | TEXT NOT NULL | |
| last_name | TEXT NOT NULL | |
| active | INTEGER NOT NULL DEFAULT 1 | 0/1 |

Índice único parcial: `(store_id, seller_code) WHERE active = 1`.

## Revisión 2 — `sales.seller_code` schema v15 (SLICE-64)

| Columna | Tipo | Notas |
|---------|------|-------|
| seller_code | TEXT NULL | Código planilla al confirmar venta (RF-084) |

## Revisión 2 — `stock_movements` guía/lote schema v16 (SLICE-65)

Migración desde v15: columnas `guide_ref`, `lot_ref` en `stock_movements` (NULL en movimientos históricos).