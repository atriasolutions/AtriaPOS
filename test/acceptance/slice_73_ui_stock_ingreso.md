# SLICE-73 — UI stock insights + ingreso guía/lote (RF-085, RF-087)

## SC-085-UI-01 — Ingreso válido

```gherkin
Dado supervisor autenticado y producto con stock 5
Cuando registro ingreso cantidad 10 guía GD-1 lote L-01
Entonces UI confirma stock 15
```

## SC-085-UI-02 — Validación formulario

```gherkin
Cuando envío sin guía, sin lote o cantidad <= 0
Entonces mensaje de validación y sin snackbar de éxito
```

## SC-085-UI-03 — Cajero sin menú ingreso

```gherkin
Dado cajero autenticado en Vender
Entonces no aparece ítem menú ingreso existencias
```

## SC-087-UI-01 — Stock bajo en pantalla

```gherkin
Dado producto con stock 2
Cuando supervisor abre stock insights
Entonces aparece en sección stock bajo
```

## SC-087-UI-02 — Top sellers tras venta

```gherkin
Dado venta confirmada del producto hoy
Cuando supervisor abre stock insights
Entonces producto aparece en más vendidos
```

## SC-087-UI-03 — Cajero sin menú insights

```gherkin
Dado cajero autenticado en Vender
Entonces no aparece ítem menú stock insights
```

Tests: `stock_receipt_ui_e2e_test.dart`, `stock_insights_ui_e2e_test.dart`, `stock_menu_cajero_ui_test.dart`.