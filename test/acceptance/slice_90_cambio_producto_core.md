# SLICE-90 — Cambio de producto (core)

**RF:** RF-095, DEC-054  
**API:** `POST .../sales/{saleId}/product-exchanges`  
**Tests:** `packages/core/test/application/register_product_exchange_test.dart`, `product_exchange_api_test.dart`

## SC-090-01 — Mismo valor

Cambio 1×1 con mismo precio: `ProductExchange`, nueva venta, stock devuelto y entregado.

## SC-090-02 — Parcial

Tres unidades vendidas: dos cambios válidos, tercero bloqueado con `CONFLICTO`.

## SC-090-03 — Mayor valor

Diferencia positiva con pago `EFECTIVO` en venta nueva.

## SC-090-04 — Menor valor

Devolución registrada con medio `OTRO`.

## SC-090-05 — Turno

Venta de otro turno o sin turno abierto → error.

## SC-090-06 — Permisos

Cajero → 403.

## SC-090-07 — Fiscal

Venta con boleta emitida → 400.

## SC-090-08 — Stock

Producto nuevo sin stock → 409.