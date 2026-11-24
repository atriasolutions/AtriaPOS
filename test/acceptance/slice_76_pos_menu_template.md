# SLICE-76 — UI menú plantilla Atria (RF-089)

## SC-076-UI-01 — Supervisor Atria ve menú completo

```gherkin
Dado plantilla ATRIA_POS y usuario supervisor con turno abierto
Cuando abre Vender y el menú operación
Entonces aparecen ítems de gestión avanzada
Y operation_menu_stock_insights y operation_menu_users están presentes
```

Verificación: `pos_menu_template_ui_e2e_test.dart`.

## SC-076-UI-02 — Cajero sin usuarios

```gherkin
Dado plantilla ATRIA_POS y usuario cajero
Cuando abre el menú operación en Vender
Entonces no aparece operation_menu_users
```

Alinea SC-089-03.

## SC-076-UI-03 — Plantilla stub oculta features

```gherkin
Dado tienda con plantilla BARRIO_MIN_TEST (solo tests)
Y supervisor con turno abierto
Cuando abre el menú operación
Entonces no aparecen ítems de features desactivadas
Y no hay operation_menu_users ni operation_menu_stock_insights
```

Alinea SC-089-04.

## SC-076-UI-04 — Checkout sin vendedor en plantilla mínima

```gherkin
Dado plantilla BARRIO_MIN_TEST sin sellerCodeCheckout
Y carro con líneas en Vender
Entonces el panel de cobro no exige selector de vendedor
Y confirm_checkout_button puede confirmar sin código
```

Alinea SC-089-05 en UI.