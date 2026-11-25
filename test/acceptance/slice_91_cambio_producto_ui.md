# SLICE-91 — UI cambio de producto en mostrador

**RF:** RF-095  
**API:** `GET .../product-exchange-context`, `POST .../product-exchanges`  
**Tests:** `get_sale_product_exchange_context_test.dart`, `product_exchange_ui_e2e_test.dart`

## SC-091-UI-01 — Mismo valor

Supervisor carga venta, cambia 1 unidad por otro producto mismo precio; snack de éxito.

## SC-091-UI-02 — Diferencia mayor

UI muestra pago de diferencia en efectivo y confirma cambio.

## SC-091-UI-03 — Cajero

`PosMenuPolicy` no incluye `productExchange` para cajero.

## SC-091-UI-04 — Boleta emitida

Carga contexto bloquea confirmación (mensaje + sin botón enviar).

## SC-091-UI-05 — Parcial repetido

Dos cambios de 1 unidad sobre venta de 2; segundo tras recargar contexto.