# Gate 0 — Piloto SLICE-8 Fase B

Registrar **antes** de activar `SII_GATEWAY=live` en dispositivo con certificado real.

## Confirmación cliente

| Campo | Valor |
|-------|-------|
| Cliente / tienda | Tienda piloto (segmento D) |
| Fecha | 2026-11-19 |
| Autoriza ambiente **certificación** SII (no producción) | ☑ Sí |
| Responsable operación | Operador piloto |

## Artefactos en dispositivo (nunca en repositorio)

- [x] Certificado `.pfx` + clave (custodia local)
- [x] CAF tipo 39 vigente (`SII_CAF_PATH`)
- [x] RUT emisor habilitado en portal certificación

## Variables piloto

Ver [`runbooks/sii-cert.md`](../runbooks/sii-cert.md) sección Fase B.

Cierre Gate 0 registrado en SLICE-37 (SC-080-03); folio y `sale_id` completos en bitácora/captura local del operador, no en git.