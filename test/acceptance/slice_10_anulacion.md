# SLICE-10 — Anulación venta (RF-032)

### SC-032-01 — Supervisor anula venta confirmada

```gherkin
Dado venta confirmada en turno abierto
Cuando supervisor anula
Entonces status ANULADA y stock restaurado por línea
```

### SC-032-02 — Cajero sin permiso

```gherkin
Dado rol cajero
Cuando intenta anular
Entonces PERMISO_DENEGADO
```

### SC-032-03 — Turno cerrado u otra ventana

```gherkin
Dado turno cerrado o venta de otro turno
Cuando supervisor anula
Entonces TURNO_CERRADO o VALIDACION
```

### SC-032-04 — Segunda anulación

```gherkin
Dado venta ya ANULADA
Cuando anula de nuevo
Entonces CONFLICTO
```

### SC-032-05 — Boleta emitida

```gherkin
Dado dteStatus EMITIDA
Cuando anula
Entonces VALIDACION (NC manual)
```

### SC-032-06 — Cola DTE pendiente

```gherkin
Dado PENDIENTE_DTE en cola
Cuando anula
Entonces ANULADA y cola sin el saleId
```

### SC-032-UI-01 — Flutter anular venta

```gherkin
Dado supervisor con venta confirmada anulable en turno
Cuando abre ventas del turno y confirma anular
Entonces la lista muestra ANULADA
```

### SC-032-07 — Cierre caja

```gherkin
Dado venta anulada en turno
Cuando cierra caja
Entonces totales ignoran la venta anulada
```