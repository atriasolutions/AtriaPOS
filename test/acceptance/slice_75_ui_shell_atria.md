# SLICE-75 — UI shell Atria (presentación Vender)

Sin RF nuevo. Menú plantilla queda en SLICE-76.

## SC-075-UI-01 — Carro vacío

```gherkin
Dado cajero en Vender sin líneas
Entonces empty state con ícono y texto de ayuda
```

## SC-075-UI-02 — Cobro en panel

```gherkin
Dado línea en carro y vendedor V01
Cuando confirmo en panel derecho
Entonces venta registrada con diálogo resultado
```

## SC-075-UI-03 — Keys operación y carrito

```gherkin
Entonces operation_menu_button y cart_line_* siguen disponibles
```

Tests: `ui_shell_sale_e2e_test.dart`; regresión `seller_code_checkout_ui_e2e_test.dart`, `sale_flow_scenario.dart`.