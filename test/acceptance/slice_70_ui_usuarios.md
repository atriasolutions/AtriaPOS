# SLICE-70 — UI usuarios (RF-080)

## SC-080-UI-01 — Lista usuarios

```gherkin
Dado sesión DUENO
Cuando abre Operación → Usuarios
Entonces ve usuarios con perfil R2
```

## SC-080-UI-02 — Editar apellido

```gherkin
Dado usuario cajero en lista
Cuando edita apellido y guarda
Entonces lista muestra nuevo displayName
```

## SC-080-UI-03 — Cambiar PIN

```gherkin
Cuando dueño cambia PIN del cajero
Entonces login con PIN nuevo funciona
```

## SC-080-UI-04 — Supervisor sin menú

```gherkin
Dado sesión SUPERVISOR
Entonces no aparece ítem Usuarios
```

Tests API: `list_users_test`, `update_user_test`, `list_users_api_test`, `update_user_auth_test`.
Tests UI: `user_management_ui_e2e_test.dart`, `user_create_ui_e2e_test.dart`.