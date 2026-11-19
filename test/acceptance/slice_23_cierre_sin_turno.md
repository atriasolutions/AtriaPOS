# SLICE-23 — Cierre sin turno (SC-041-02 UI)

Referencia: [`slice_04_turno.md`](slice_04_turno.md) SC-041-02 (core).

## SC-041-UI-03 — Pantalla muestra aviso

```gherkin
Dado supervisor autenticado sin turno abierto
Cuando abre Operación → Cerrar caja
Entonces ve mensaje de sin turno y no puede confirmar cierre
```

Verificación: `apps/pos_app/test/close_shift_ui_e2e_test.dart`