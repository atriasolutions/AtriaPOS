# SLICE-64 — Código vendedor en venta (RF-084)

Referencia: DEC-049, SLICE-63 planilla.

## SC-084-01 — Checkout con código activo

```gherkin
Dado colaborador activo V01
Cuando checkout con sellerCode V01
Entonces venta persiste sellerCode
```

## SC-084-02 — Sin código

```gherkin
Cuando checkout sin sellerCode
Entonces VALIDACION 400
```

## SC-084-03 — Código inactivo

```gherkin
Dado colaborador V02 desactivado
Cuando checkout con V02
Entonces VALIDACION 400
```

## SC-084-04 — Listar activos para venta

```gherkin
Dado cajero autenticado
Cuando GET colaboradores activos
Entonces 200 solo activos
```

## SC-084-05 — Supervisor lista activos sin CRUD planilla

```gherkin
Dado supervisor
Entonces puede listar activos y no crear planilla
```

## SC-084-06 — Drift persiste seller_code

```gherkin
Cuando venta confirmada en drift
Entonces columna seller_code poblada
```

Tests: `confirm_checkout_test`, `seller_code_checkout_test`, `drift_sale_test`.