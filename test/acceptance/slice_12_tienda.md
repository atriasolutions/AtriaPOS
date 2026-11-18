# SLICE-12 — Alta de tienda (RF-001 / API-007)

### SC-001-01 — Bootstrap tienda válida

```gherkin
Dado que no existe tienda en el dispositivo
Cuando el dueño completa RUT válido, razón social, giro, nombre y PIN
Entonces se persiste la tienda, usuario DUENO y sesión activa
```

### SC-001-02 — RUT inválido

```gherkin
Dado bootstrap sin tienda previa
Cuando guarda con RUT inválido
Entonces VALIDACION y sin persistencia
```

### SC-001-03 — Segunda tienda

```gherkin
Dado tienda ya registrada
Cuando intenta bootstrap nuevamente
Entonces CONFLICTO
```

### SC-001-UI-01 — Onboarding en app

```gherkin
Given app sin filas en stores
When completa formulario de alta
Then pantalla de abrir turno o login según flujo y storeId distinto de demo fijo
```