# SLICE-20 — Auditoría mínima consultable (RF-070 / API-009)

## SC-070-01 — Venta y ajuste con actor en traza del día

```gherkin
Dado supervisor con turno abierto
Cuando confirma una venta y registra una merma
Entonces GetAuditTrail lista CONFIRMA_VENTA y AJUSTE_STOCK con actorUserId
```

Verificación: `packages/core/test/application/get_audit_trail_test.dart`, `packages/core/test/api/report_service_test.dart`

## SC-070-UI-01 — Pantalla auditoría en app

```gherkin
Dado supervisor con venta y merma del día
Cuando abre Operación → Auditoría del día
Entonces la lista muestra eventos con actor usr_supervisor
```

Verificación: `apps/pos_app/test/audit_trail_ui_e2e_test.dart`

## SC-070-UI-02 — Cajero sin menú auditoría

```gherkin
Dado sesión CAJERO en Vender
Cuando revisa menú Operación
Entonces no aparece "Auditoría del día"
```

Verificación: mismo archivo.