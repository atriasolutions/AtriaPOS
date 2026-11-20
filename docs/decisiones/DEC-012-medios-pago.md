# DEC-012 — Medios de pago MVP (EFECTIVO, OTRO)

- **Estado:** Aceptado (retroactivo SLICE-45)
- **Fecha:** 2026-11-20
- **Prioridad:** P0
- **Relacionado:** RF-031, SLICE-3, DEC-042, API-004

## Contexto

El contrato de checkout y el cierre de caja necesitan medios de pago acotados para segmento D.

## Decisión

1. **Enum dominio:** `PaymentMethod.efectivo` (`EFECTIVO`) y `PaymentMethod.otro` (`OTRO`) en `payment_method.dart`.
2. **Checkout:** lista de pagos en `ConfirmCheckoutInput`; validación de total cobrado ≥ total venta y `changeClp` coherente.
3. **Cierre caja:** efectivo esperado usa pagos **EFECTIVO** (DEC-015 / turno).
4. **Fuera de MVP:** tarjeta integrada, mixtos avanzados y terminal — SLICE-9 **N/A**.

Alineado con [`DEC-venta-slice3.md`](DEC-venta-slice3.md) y DEC-042.

## Alternativas descartadas

| Alternativa | Motivo |
|-------------|--------|
| Solo EFECTIVO | RF y caja contemplan “otro” para registro simple |
| Medios SII adicionales en enum | Sin integración terminal en MVP |

## Impacto

- Doc 07 payloads `payments[].method`
- Persistencia `payments` en drift schema v3+

## Verificación

- `sale_service_test.dart` SC-031, dominio `PaymentMethod.fromApi`, UI cobro efectivo en SC-060-01.