# SLICE-67 — Stock insights (RF-087)

Consulta stock bajo + top ventas 30 días vía API-008.

## SC-087-01 — Default umbral

```gherkin
Dado producto stock 2 sin umbral custom
Cuando consulto stock-insights
Entonces aparece en lowStock con umbral efectivo 5
```

## SC-087-02 — Umbral por producto

```gherkin
Dado producto con lowStockThreshold 10 y stock 8
Cuando consulto lowStock
Entonces incluye el producto
```

## SC-087-03 — Top 30 días

```gherkin
Dado ventas confirmadas con líneas en ventana 30d
Cuando consulto topSellers
Entonces orden por unidades vendidas
```

## SC-087-04 — Excluye anuladas

```gherkin
Dado venta anulada en ventana
Entonces no suma al top
```

## SC-087-05 — limit

```gherkin
Cuando limit=2 con 3 productos vendidos
Entonces topSellers tiene largo 2
```

## SC-087-06 — Cajero

```gherkin
Cuando cajero consulta
Entonces 403
```

## SC-087-07 — Drift umbral

```gherkin
Cuando guardo producto con lowStockThreshold
Entonces persiste en drift
```

## SC-087-08 — asOf

```gherkin
Cuando asOf fija fin de ventana
Entonces agregación respeta esa fecha
```

Tests: `get_stock_insights_test`, `stock_insights_api_test`, `drift_stock_insights_test`.