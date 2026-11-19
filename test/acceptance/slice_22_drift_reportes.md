# SLICE-22 — Persistencia Drift: reportes y auditoría

Slice de calidad: mismos escenarios que acceptance previos, con repos Drift.

## SC-060-02 — Reporte diario en Drift

```gherkin
Dado ventas persistidas en SQLite con anuladas y otro día
Cuando GetDailySalesReport consulta el día calendario
Entonces totales y promedio coinciden con SC-060-02 core
```

Verificación: `packages/adapters/test/drift_daily_report_test.dart`

## SC-070-01 — Auditoría y movimientos en Drift

```gherkin
Dado checkout y merma persistidos en SQLite con sesión supervisor
Cuando GetAuditTrail consulta el día y listByStoreCreatedBetween filtra movimientos
Entonces confirmedByUserId en venta y actores en traza; sin duplicar VENTA
```

Verificación: `drift_audit_trail_test.dart`, `drift_stock_movement_range_test.dart`