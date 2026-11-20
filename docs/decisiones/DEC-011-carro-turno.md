# DEC-011 — Carro: uno por cajero / por turno

- **Estado:** Aceptado (retroactivo SLICE-45)
- **Fecha:** 2026-11-20
- **Prioridad:** P0
- **Relacionado:** RF-030, SLICE-3/6, DEC-013

## Contexto

Hay que definir alcance del carrito respecto al turno y al dispositivo sin multi-carro concurrente en MVP.

## Decisión

1. **Persistencia carro:** `InMemoryCartRepository` en runtime (no sobrevive reinicio app) — ver [`DEC-ui-slice6.md`](DEC-ui-slice6.md).
2. **Vínculo turno:** al crear carro, `CreateCart` asigna `shiftId` del turno **ABIERTO** de la tienda si existe (`create_cart.dart`).
3. **Política MVP:** la UI mantiene **un flujo de venta activo** (un `cartId` en uso en `SaleScreen`); no hay cola de carros paralelos por cajero en el mismo dispositivo.
4. **Checkout:** `ConfirmCheckout` exige turno abierto (DEC-013); al completar, el carro pasa a estado completado en memoria.

## Alternativas descartadas

| Alternativa | Motivo |
|-------------|--------|
| Carro persistido en SQLite por sesión | Diferido; mayor complejidad sin RF [M] explícito |
| Un carro global por tienda compartido | No aplica a un POS por dispositivo en MVP |

## Impacto

- API-004 carro/checkout en doc 07
- `packages/core/lib/application/create_cart.dart`, `in_memory_cart_repository.dart`

## Verificación

- SC-030-01 `create_cart_test.dart`, SC-060-01 flujo venta UI, SC-031-05 sin turno.