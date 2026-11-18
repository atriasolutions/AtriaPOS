# Gate 0 — Piloto SLICE-8 Fase B

Registrar **antes** de activar `SII_GATEWAY=live` en dispositivo con certificado real.

## Confirmación cliente

| Campo | Valor |
|-------|-------|
| Cliente / tienda | _(completar)_ |
| Fecha | _(completar)_ |
| Autoriza ambiente **certificación** SII (no producción) | ☐ Sí |
| Responsable operación | _(nombre)_ |

## Artefactos en dispositivo (nunca en repositorio)

- [ ] Certificado `.pfx` + clave (custodia local)
- [ ] CAF tipo 39 vigente (`SII_CAF_PATH`)
- [ ] RUT emisor habilitado en portal certificación

## Variables piloto

Ver [`runbooks/sii-cert.md`](../runbooks/sii-cert.md) sección Fase B.