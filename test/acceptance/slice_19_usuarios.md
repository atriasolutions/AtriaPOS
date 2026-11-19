# SLICE-19 — Usuarios en UI (RF-002)

Referencia matriz RF-002 y DEC: [`docs/decisiones/DEC-auth-slice7.md`](../docs/decisiones/DEC-auth-slice7.md).

## SC-070-UI-01 — Dueño crea cajero

```gherkin
Dado sesión DUENO y turno abierto
Cuando abre Operación → Nuevo usuario y completa formulario válido
Entonces el usuario queda guardado y puede iniciar sesión con su PIN
```

Verificación: `apps/pos_app/test/user_create_ui_e2e_test.dart`

## SC-070-UI-02 — Supervisor sin gestión usuarios

```gherkin
Dado sesión SUPERVISOR en Vender
Cuando revisa menú Operación
Entonces no aparece "Nuevo usuario"
```

Verificación: mismo archivo.