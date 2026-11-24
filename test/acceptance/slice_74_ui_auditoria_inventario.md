# SLICE-74 — UI auditoría ampliada y cierre inventario (RF-086, RF-088)

## SC-086-UI-01 — Filtro VENTAS

```gherkin
Dado venta y ajuste stock el mismo día
Cuando filtro categoría VENTAS en auditoría
Entonces no aparece AJUSTE_STOCK
```

## SC-086-UI-02 — Rango en cabecera

```gherkin
Cuando consulto con from/to de hoy
Entonces cabecera muestra el rango y lista eventos del día
```

## SC-086-UI-03 — Rango inválido

```gherkin
Cuando hasta es anterior a desde
Entonces mensaje de validación sin actualizar lista con éxito
```

Rango multi-día: cubierto en core (`audit_trail_range_test`).

## SC-088-UI-01 — Preview

```gherkin
Dado turno abierto y venta de 1 unidad
Cuando abro cierre inventario
Entonces veo systemStock y unitsSoldInShift
```

## SC-088-UI-02 — Cierre con corrección

```gherkin
Cuando ingreso countedQty distinto al sistema
Entonces confirmación UI con variance
```

## SC-088-UI-03 — Sin turno

```gherkin
Cuando no hay turno abierto
Entonces mensaje sin lista de productos
```

## SC-088-UI-04 — Cajero sin menú

```gherkin
Dado cajero en Vender
Entonces no aparece ítem cierre inventario
```

Tests: `audit_trail_range_ui_e2e_test.dart`, `inventory_close_ui_e2e_test.dart`, `inventory_close_menu_cajero_ui_test.dart`; regresión `audit_trail_ui_e2e_test.dart`.