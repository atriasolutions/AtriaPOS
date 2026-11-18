# SLICE-5 — DTE fake (RF-050, RF-051)

### SC-050-01 — Emisión exitosa

```gherkin
Dado venta confirmada con FakeDteGateway ok
Entonces checkout indica dteStatus EMITIDA y folio
```

### SC-051-01 — Fallo emisión

```gherkin
Dado gateway falla
Cuando checkout válido
Entonces venta existe, stock descontado, PENDIENTE_DTE y cola
```

### SC-051-02 — Reintento cola

```gherkin
Dado venta pendiente en cola
Cuando POST dte-queue/retry
Entonces processed >= 1 y venta EMITIDA
```

### SC-051-03 — Rechazo SII (opcional)

```gherkin
Dado FakeDteGateway en modo rechazo
Cuando checkout válido
Entonces RECHAZADA_SII y sin ítem en cola
```