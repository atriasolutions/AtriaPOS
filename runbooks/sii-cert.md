# Runbook — Certificación SII (boleta 39)

## Fase A (desarrollo, sin red SII)

- Gateway: `SiiCertReplayDteGateway` con escenario `success` | `timeout` | `rechazada`.
- Certificado: fixture PEM de prueba o `SII_CERT_PATH` apuntando a PEM local (no commitear `.pfx`).
- Rollback: `SII_GATEWAY=fake` (default).

Variables sugeridas:

| Variable | Uso |
|----------|-----|
| `SII_CERT_PATH` | Ruta absoluta a certificado PEM (solo dev/piloto) |
| `SII_GATEWAY` | `fake` (default) o `replay` |
| `SII_REPLAY_SCENARIO` | `success`, `timeout`, `rechazada` |

```powershell
flutter run --dart-define=SII_GATEWAY=replay --dart-define=SII_REPLAY_SCENARIO=success
```

## Prerrequisitos Fase B (piloto con red)

- RUT emisor habilitado en ambiente **certificación** SII.
- Certificado digital `.pfx` + clave (custodia local, nunca en repo).
- CAF/folios de certificación vigentes.
- Confirmación explícita del cliente antes de usar certificado real.

## Checklist emisión cert (Fase B — manual SC-080-03)

- [ ] Certificado vigente (`ValidateCertificate` sin error).
- [ ] Venta checkout → `dteStatus` EMITIDA y folio numérico.
- [ ] Folio visible en portal certificación SII (evidencia captura/archivo).
- [ ] Fallo red simulado → `PENDIENTE_DTE` y ítem en cola (API-005 retry).
- [ ] Volver a `SII_GATEWAY=fake` para demos sin cert.

## Rollback

1. `SII_GATEWAY=fake` en build/run.
2. No borrar cola `dte_queue` en SQLite si hay pendientes productivos.
3. Revocar acceso a `.pfx` en dispositivo si comprometido.