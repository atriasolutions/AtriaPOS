# DEC — SII SLICE-8 (certificación por fases)

- **Estado:** Fase A y B implementadas; piloto manual SC-080-03 pendiente de operación en cert
- **Fecha:** 2026-11-18

| DEC / Tema | Decisión |
|------------|----------|
| DEC-021 | Certificado solo en filesystem / keystore OS; `SII_CERT_PATH` (.pem o .pfx); `SII_CERT_PASSWORD` solo dart-define local; sin clave en repo ni DB |
| DEC-043 (F3-4) | CAF XML en filesystem (`SII_CAF_PATH`); rango en SQLite (`dte_folio_counters`); siguiente folio atómico por tienda y tipo DTE |
| Fase A | `SiiCertReplayDteGateway` sin red; fixtures/escenarios |
| Fase B | `SiiLiveDteGateway` + `HttpSiiTransport`; confirmación cliente antes de piloto con red |
| Puente RF-001 | ~~dart-define emisor~~ sustituido por tienda en DB (SLICE-12); env solo legacy/tests |
| Default app | `FakeDteGateway`; `SII_GATEWAY=replay` dev; `SII_GATEWAY=live` solo piloto cert |
| Ambiente | `SII_AMBIENTE=cert` → base Maullin; producción explícitamente fuera de MVP |
| Fallos red | `PENDIENTE_DTE` + cola API-005 |
| Rechazo SII | `RECHAZADA_SII` sin reencolar |
| Kora | Complemento opcional; no reemplaza puerto `DteGateway` |

DoD Fase A: replay + runbook + DEC-021. DoD completo slice: Fase B + checklist SC-080-03 en piloto.

**SLICE-25 (prep piloto):** índice operativo [`runbooks/sii-piloto-indice.md`](../../runbooks/sii-piloto-indice.md), pre-vuelo en evidencia, guía UI en consulta certificado; no equivale a cerrar SC-080-03.