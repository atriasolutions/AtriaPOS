# SLICE-68 — Cierre inventario (RF-088)

Cruce stock sistema, ventas del turno y recuento manual.

## SC-088-01 — Preview

```gherkin
Dado turno abierto con ventas
Cuando GET inventory-close/preview
Entonces systemStock y unitsSoldInShift por SKU
```

## SC-088-02 — Cierre con corrección

```gherkin
Cuando POST líneas con countedQty distinto al sistema
Entonces stock contado y movimiento CORRECCION
```

## SC-088-03 — Variance cero

```gherkin
Cuando countedQty igual systemStock
Entonces sin movimiento, línea persistida
```

## SC-088-04 — Anuladas

```gherkin
Venta anulada en turno no suma unitsSoldInShift
```

## SC-088-05 — Sin turno

```gherkin
Entonces 404
```

## SC-088-06 — Cajero

```gherkin
Entonces 403
```

## SC-088-07 — Drift

```gherkin
Persiste inventory_closes y líneas
```

## SC-088-08 — Validación

```gherkin
countedQty negativo o duplicado → 400
```

Tests: `get_inventory_close_preview_test`, `close_inventory_test`, `inventory_close_api_test`, `drift_inventory_close_test`.