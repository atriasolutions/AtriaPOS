# SLICE-66 — Auditoría rango y categoría (RF-086)

Extiende RF-070 / API-009.

## SC-086-01 — Rango multi-día

```gherkin
Dado eventos en dos días del rango
Cuando consulto audit-trail from/to 7 días
Entonces items de ambos días
```

## SC-086-02 — Rango inválido

```gherkin
Cuando rango mayor a 31 días o to antes de from
Entonces VALIDACION 400
```

## SC-086-03 — Filtro VENTAS

```gherkin
Cuando categories=VENTAS
Entonces solo CONFIRMA_VENTA y ANULA_VENTA
```

## SC-086-04 — Filtro USUARIOS

```gherkin
Cuando categories=USUARIOS
Entonces solo CREA_USUARIO
```

## SC-086-05 — PAGOS stub

```gherkin
Cuando categories=PAGOS
Entonces 200 lista vacía
```

## SC-086-06 — Legacy date=

```gherkin
Cuando date=YYYY-MM-DD
Entonces equivalente a un día SC-070
```

## SC-086-07 — Drift metadatos

```gherkin
Cuando void y create user
Entonces voided_at y created_at persistidos
```

## SC-086-08 — ANULA_VENTA

```gherkin
Cuando anulo venta
Entonces auditoría VENTAS incluye ANULA_VENTA por voidedAt
```

Tests: `get_audit_trail_test`, `audit_trail_range_test`, `drift_audit_trail_range_test`.