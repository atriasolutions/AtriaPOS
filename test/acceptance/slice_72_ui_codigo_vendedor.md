# SLICE-72 — UI código vendedor checkout (RF-084)

## SC-084-UI-01 — Selección y venta

```gherkin
Dado colaborador activo V01
Cuando cobro y elijo vendedor V01
Entonces venta confirmada con sellerCode
```

## SC-084-UI-02 — Sin vendedor

```gherkin
Cuando no hay código seleccionado
Entonces confirmar venta deshabilitado
```

## SC-084-UI-03 — Código inválido

```gherkin
Cuando ingreso código inexistente
Entonces mensaje de validación
```

Tests: `seller_code_checkout_ui_e2e_test.dart`; regresión `sale_flow_scenario.dart`.