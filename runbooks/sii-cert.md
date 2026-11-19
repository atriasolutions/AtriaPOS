# Runbook — Certificación SII (boleta 39)

## Fase A (desarrollo, sin red SII)

- Gateway: `SiiCertReplayDteGateway` con escenario `success` | `timeout` | `rechazada`.
- Certificado: fixture PEM de prueba o `SII_CERT_PATH` apuntando a PEM local (no commitear `.pfx`).
- Rollback: `SII_GATEWAY=fake` (default).

Variables sugeridas:

| Variable | Uso |
|----------|-----|
| `SII_CERT_PATH` | Ruta absoluta a certificado PEM o `.pfx` (solo dev/piloto) |
| `SII_CERT_PASSWORD` | Clave del `.pfx` (solo dart-define local) |
| `SII_GATEWAY` | `fake` (default), `replay` o `live` |
| `SII_REPLAY_SCENARIO` | `success`, `timeout`, `rechazada` |

```powershell
flutter run --dart-define=SII_GATEWAY=replay --dart-define=SII_REPLAY_SCENARIO=success
```

## Fase B (emisión live en certificación)

Antes de piloto: completar [`docs/gate0-slice8b-piloto.md`](../docs/gate0-slice8b-piloto.md) y seguir el índice [`sii-piloto-indice.md`](sii-piloto-indice.md).

| Variable | Uso |
|----------|-----|
| `SII_GATEWAY` | `live` |
| `SII_AMBIENTE` | `cert` (default Maullin) — **no** `prod` en MVP |
| `SII_CAF_PATH` | Ruta al XML CAF tipo 39 |
| `SII_RUT_EMISOR` | RUT emisor habilitado en portal cert |
| `SII_RAZON_SOCIAL` | Razón social emisor (puente hasta RF-001) |
| `SII_GIRO` | Giro emisor |

```powershell
flutter run -d windows `
  --dart-define=SII_GATEWAY=live `
  --dart-define=SII_AMBIENTE=cert `
  --dart-define=SII_CERT_PATH=C:\secure\emisor.pfx `
  --dart-define=SII_CERT_PASSWORD=*** `
  --dart-define=SII_CAF_PATH=C:\secure\caf39.xml `
  --dart-define=SII_RUT_EMISOR=76192083-9 `
  --dart-define=SII_RAZON_SOCIAL="Mi Tienda SpA" `
  --dart-define=SII_GIRO="Almacen"
```

Evidencia manual: [`sii-cert-pilot-evidence.md`](sii-cert-pilot-evidence.md).

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