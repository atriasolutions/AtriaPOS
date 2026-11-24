# SLICE-71 — UI carrito editable (RF-082)

## SC-082-UI-01 — Bajar cantidad

```gherkin
Dado cajero en Vender con 2 unidades en carro
Cuando pulsa menos en la línea
Entonces total recalculado a una unidad
```

## SC-082-UI-02 — Eliminar línea

```gherkin
Dado una línea en el carro
Cuando elimina la línea
Entonces carro vacío
```

## SC-082-UI-03 — Supervisor edita

```gherkin
Dado supervisor en Vender
Cuando cambia cantidad o elimina línea
Entonces mismo comportamiento que cajero
```

Tests: `apps/pos_app/test/cart_editable_ui_e2e_test.dart`.