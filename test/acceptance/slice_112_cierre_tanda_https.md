# SLICE-112 — Cierre tanda companion HTTPS (106–112)

## Checklist DoD

- [x] Slices 107–111 cerrados en código y docs
- [x] SC-112-01…04 automatizados
- [x] Regresión companion en `companion_lan_e2e_test.dart`
- [x] `scripts/ci-local.ps1` cubre `pos_app` (incluye flow e2e)
- [x] Acceptance 112 + esta acta
- [ ] Piloto manual HTTPS triple flujo (PREPARADO en runbook)

## Slices de la tanda

| Slice | Entrega |
|-------|---------|
| 106 | DEC-059…062 |
| 107 | Enlace corto `/c/` |
| 108 | PWA simple |
| 109 | HTTPS + CA |
| 110 | Cámara opcional |
| 111 | Estado celular POS |
| 112 | E2E negocio tres modos |

## Evidencia automatizada

`packages/core`, `packages/adapters`, `apps/companion_web`, `apps/pos_app/test/companion_lan_*`