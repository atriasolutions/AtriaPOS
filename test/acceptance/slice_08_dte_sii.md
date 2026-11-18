# SLICE-8 — DTE SII certificación (fases)

### SC-080-01 — Replay certificado válido → EMITIDA

```gherkin
Dado certificado vigente y escenario replay success
Cuando se emite DTE para una venta
Entonces dteStatus EMITIDA y folio según fixture
```

### SC-080-02 — Certificado vencido o ausente

```gherkin
Dado certificado vencido o no configurado
Cuando se emite DTE
Entonces PENDIENTE_DTE y cola actualizada (stock sin revertir)
```

### SC-080-03 — Ambiente certificación SII (Fase B, manual)

```gherkin
Dado .pfx del cliente en dispositivo piloto y gateway live
Cuando venta real en certificación
Entonces folio validado en portal SII (checklist runbook)
```

### SC-080-04 — Live transport timeout

```gherkin
Dado SiiLiveDteGateway con transport que simula timeout
Cuando emisión DTE
Entonces PENDIENTE_DTE y cola actualizada
```

### SC-080-05 — Live transport rechazo SII

```gherkin
Dado transport que simula rechazo SII
Cuando emisión DTE
Entonces RECHAZADA_SII sin ítem en cola
```