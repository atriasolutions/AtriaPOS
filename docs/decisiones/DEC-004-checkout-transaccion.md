# DEC-004 — Transacción única checkout

- **Estado:** Aceptado (retroactivo SLICE-45)
- **Fecha:** 2026-11-20
- **Prioridad:** P0
- **Relacionado:** RF-030, RF-031, SLICE-3/5, DEC-042

## Contexto

El checkout debe dejar venta, líneas, pagos, stock y DTE en un estado coherente ante fallos parciales.

## Decisión

1. **Unidad lógica:** el caso de uso `ConfirmCheckout` en `packages/core` orquesta validación de turno, carro, stock, pagos, descuento de inventario, persistencia de venta, emisión DTE y cierre del carro en una sola operación síncrona desde la API.
2. **Persistencia atómica de venta:** `DriftSaleRepository.save` envuelve inserción de `sales`, `sale_lines` y `payments` en **una** `transaction` Drift.
3. **Fuera de la misma transacción SQL:** actualización de `products.stock`, `stock_movements`, cola DTE y segundo `save` de venta post-DTE — orden fijo en `ConfirmCheckout`; deuda aceptada para MVP local-first (rollback manual vía anulación donde aplique).

## Alternativas descartadas

| Alternativa | Motivo |
|-------------|--------|
| Saga distribuida / outbox en SLICE-3 | Complejidad innecesaria para segmento D |
| Una sola transacción SQL incluyendo stock y DTE | DTE es IO externo; no bloquear DB en gateway live |

## Impacto

- [`docs/06-arquitectura.md`](../06-arquitectura.md) — flujo venta
- `packages/core/lib/application/confirm_checkout.dart`
- `packages/adapters/lib/drift_sale_repository.dart`

## Verificación

- Tests `confirm_checkout_*`, `drift_sale_test.dart`, SC-031 en acceptance.