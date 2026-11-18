# SLICE-7 — Roles y PIN (RF-002)

### SC-070-01 — Login válido

```gherkin
Dado usuario cajero con PIN correcto
Cuando POST auth/login
Entonces 200 con role CAJERO y token local
```

### SC-070-02 — PIN incorrecto

```gherkin
Cuando PIN inválido
Entonces CREDENCIAL_INVALIDA 401
```

### SC-070-03 — Matriz permisos

```gherkin
Dado sesión CAJERO
Cuando ajuste inventario o cierre caja
Entonces PERMISO_DENEGADO 403
Dado sesión SUPERVISOR
Cuando ajuste o cierre
Entonces éxito
```

### SC-070-04 — Gestionar usuarios

```gherkin
Dado sesión CAJERO
Cuando crear usuario
Entonces 403
Dado sesión DUENO
Cuando crear usuario
Entonces 201
```