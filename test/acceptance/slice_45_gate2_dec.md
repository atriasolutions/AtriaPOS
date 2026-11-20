# SLICE-45 — Gate 2 DEC retroactivos (004, 005, 011, 012)

Documentación alineada al MVP implementado; Gate 2 global sigue parcial en doc 17.

## SC-G2-004 — Transacción checkout (DEC-004)

```gherkin
Dado ConfirmCheckout como orquestador de venta
Cuando se persiste una venta en adaptadores
Entonces DriftSaleRepository usa transaction para sales, sale_lines y payments
Y el ADR DEC-004 documenta stock/DTE fuera de esa transaction SQL
```

Verificación: [`docs/decisiones/DEC-004-checkout-transaccion.md`](../../docs/decisiones/DEC-004-checkout-transaccion.md); `packages/adapters/lib/drift_sale_repository.dart`; tests `confirm_checkout_*`, `drift_sale_test.dart`.

## SC-G2-005 — API in-process (DEC-005)

```gherkin
Dado los servicios API en packages/core/lib/api
Cuando se ejecutan tests packages/core/test/api
Entonces ApiResult refleja códigos del contrato doc 07 sin servidor HTTP
```

Verificación: [`docs/decisiones/DEC-005-api-in-process.md`](../../docs/decisiones/DEC-005-api-in-process.md); suite `dart test packages/core`.

## SC-G2-011 — Carro y turno (DEC-011)

```gherkin
Dado turno abierto en la tienda
Cuando CreateCart crea un carro
Entonces el carro referencia shiftId del turno abierto
Y el carrito vive en InMemoryCartRepository según DEC-ui-slice6
```

Verificación: [`docs/decisiones/DEC-011-carro-turno.md`](../../docs/decisiones/DEC-011-carro-turno.md); `create_cart_test.dart`, SC-060-01 UI.

## SC-G2-012 — Medios de pago (DEC-012)

```gherkin
Dado checkout con pagos
Cuando el medio es EFECTIVO u OTRO
Entonces PaymentMethod valida y persiste en tabla payments
```

Verificación: [`docs/decisiones/DEC-012-medios-pago.md`](../../docs/decisiones/DEC-012-medios-pago.md); `payment_method.dart`, SC-031 tests.

## SC-G2-045-DOC — Registro maestro

```gherkin
Dado SLICE-45 cerrado
Cuando se lee docs/16-registro-decisiones.md
Entonces DEC-004, 005, 011 y 012 figuran en estado Decidido con enlace ADR
Y doc 17 incluye sección Retroactivo SLICE-45 sin marcar Gate 2 completo
```

Verificación: `docs/16-registro-decisiones.md`, `docs/17-cierre-gate-2.md`.