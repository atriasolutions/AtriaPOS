# SLICE-82 — Cambiar sesión

## SC-082-01

```gherkin
Dado turno cerrado y sesión activa
Cuando solicita cambiar sesión
Entonces limpia sesión y muestra login
```

## SC-082-02

```gherkin
Dado turno abierto
Cuando solicita cambiar sesión
Entonces muestra mensaje de cierre de caja
```

Verificación: `end_session_test.dart`, UI `sale_change_session` en pantalla **Opciones** (sección Ventas y cobro).