# DEC — SII SLICE-8 (certificación por fases)

- **Estado:** Aceptado Fase A
- **Fecha:** 2026-11-18

| DEC / Tema | Decisión |
|------------|----------|
| DEC-021 | Certificado solo en filesystem / keystore OS; variable `SII_CERT_PATH`; sin PIN en repo ni DB |
| Fase A | `SiiCertReplayDteGateway` sin red; fixtures/escenarios |
| Fase B | `SiiLiveDteGateway` tras confirmación cliente + .pfx fuera del repo |
| Default app | `FakeDteGateway`; `--dart-define=SII_GATEWAY=replay` solo dev |
| Ambiente | Certificación SII (Maullin u homólogo vigente) en Fase B |
| Kora | Complemento opcional; no reemplaza puerto `DteGateway` |

DoD Fase A: replay + runbook + DEC-021. DoD completo slice: Fase B manual OK.