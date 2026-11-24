# SLICE-65 — Ingreso existencias + guía/lote (RF-085)

Referencia: RF-085, DEC-inventario (ingreso vía stock-receipts).

## SC-085-01 — Ingreso válido

```gherkin
Dado producto existente con stock 5
Cuando ingreso quantity 10 guía GD-1 lote L-01
Entonces stock 15 y movimiento RECEPCION con refs
```

## SC-085-02 — Referencias inválidas

```gherkin
Cuando ingreso sin guía o lote o quantity <= 0
Entonces VALIDACION 400
```

## SC-085-03 — SKU inexistente

```gherkin
Cuando ingreso sobre producto desconocido
Entonces NO_ENCONTRADO 404
```

## SC-085-04 — Cajero sin permiso

```gherkin
Dado cajero autenticado
Cuando ingreso existencias
Entonces PERMISO_DENEGADO 403
```

## SC-085-05 — Bloqueo RECEPCION en adjustments

```gherkin
Cuando POST adjustments con reason RECEPCION
Entonces VALIDACION 400
```

## SC-085-06 — Drift persiste guide_ref y lot_ref

```gherkin
Cuando ingreso en drift
Entonces columnas guide_ref y lot_ref pobladas
```

## SC-085-07 — Auditoría del día

```gherkin
Cuando consulto auditoría del día con ingreso
Entonces summary incluye guía y lote
```

Tests: `record_stock_receipt_test`, `stock_receipt_api_test`, `drift_stock_receipt_test`, `get_audit_trail_test`.