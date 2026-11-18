# 11 — Riesgos y supuestos

## Supuestos

| ID | Supuesto | Etiqueta |
|----|----------|----------|
| S-01 | Un dispositivo = una tienda en MVP | INFERIDO |
| S-02 | Boleta es suficiente; factura en slice posterior | OBSERVADO (barrio) |
| S-03 | Cliente provee certificado digital válido | OBSERVADO |
| S-04 | Flutter cubre Android + Windows para el piloto | OBSERVADO |
| S-05 | No se replica catálogo colaborativo Localshop en v1 | ESPECULATIVO |
| S-06 | Kora es complemento opcional; el núcleo POS no lo requiere | OBSERVADO (doc 14, D7) |

## Riesgos

| ID | Riesgo | Impacto | Mitigación |
|----|--------|---------|------------|
| R-01 | Certificación SII demora | Alto | `DteGateway` + mock desde día 1 |
| R-02 | Política stock vs DTE mal elegida | Medio | Decisión explícita Gate 1 (doc 08) |
| R-03 | Scope creep ERP | Alto | Lista “fuera de alcance” doc 00 |
| R-04 | Offline mal explicado al usuario | Medio | Estados UI + cola visible |
| R-05 | Performance SQLite &gt; 5k SKU | Medio | Índices; benchmark en SLICE-1 |
| R-06 | PII / certificado en logs | Alto | RNF-021, revisión seguridad pre-prod |

## Deuda técnica aceptada (MVP)

- Sin sync nube.
- Sin multi-tienda en un dispositivo.
- Reportes mínimos.
- Internacionalización solo es-CL.