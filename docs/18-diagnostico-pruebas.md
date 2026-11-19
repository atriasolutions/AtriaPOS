# 18 — Diagnóstico de pruebas (pre–próximo slice)

**Fecha:** 2026-11-19  
**Slice:** SLICE-36 (operativo, sin RF nuevo)  
**Rama:** `feat/slice-0-scaffold`  
**Objetivo:** evidencia objetiva para elegir el próximo slice de **producto** (SII, PR, BLE).

Referencia: [`09-estrategia-tdd.md`](09-estrategia-tdd.md), [`12b-matriz-verificacion-automatizacion.md`](12b-matriz-verificacion-automatizacion.md), [`runbooks/test-diagnostico-evidence.md`](../runbooks/test-diagnostico-evidence.md).

---

## 1. Baseline ejecutiva

### 1.1 Suites en CI / `ci-local.ps1`

| Paquete | Tests | Duración aprox. [OBSERVADO] | Estado |
|---------|-------|-----------------------------|--------|
| `packages/core` | 114 | ~16 s | Verde |
| `packages/adapters` | 25 | ~12 s | Verde |
| `apps/pos_app` | 27 | ~37 s | Verde |
| **Total MVP CI** | **166** | **~65 s** | Verde |

### 1.2 Fuera de CI

| Ubicación | Tests | Duración | Estado |
|-----------|-------|----------|--------|
| `apps/scanner_companion` | 1 | ~7 s | Verde |
| `apps/pos_app/integration_test` | 1 (SC-060-01) | No medido en este diagnóstico | Duplica `sale_flow_e2e_test.dart` |

### 1.3 Tests sensibles (flaky conocido)

| Archivo | Duración | Nota |
|---------|----------|------|
| `sii_checkout_evidence_ui_test.dart` | ~8 s | SC-080-ASSIST-UI-01/02; requiere mock `SystemChannels.platform` para portapapeles |
| `scanner_ble_ui_test.dart` + `scanner_ble_push_test.dart` | ~23 s total (con SII) | Sin cuelgue en esta corrida |

---

## 2. Trazabilidad escenario ↔ test

### 2.1 Pendientes manuales (bloquean relato “producción fiscal” / merge)

| ID | Prioridad negocio | Evidencia |
|----|-------------------|-----------|
| **SC-080-03** | Alta | `runbooks/sii-cert-pilot-evidence.md` → **CERRADO** |
| **SC-030-01** | Media | PR en `runbooks/pr-merge-evidence.md`; requiere `origin` + `gh auth` |
| **SC-011-BLE-01** | Baja | `runbooks/ble-scanner-pilot-evidence.md` → **CERRADO** |

### 2.2 Registro en 12b — huecos propuestos (no aplicados en SLICE-36)

Tests existentes sin fila en [`12b`](12b-matriz-verificacion-automatizacion.md):

| ID | Capa | Archivo |
|----|------|---------|
| SC-080-01 | Adapters | `sii_cert_replay_gateway_test.dart` |
| SC-080-02 | Adapters | Idem |
| SC-080-04 | Adapters | `sii_live_dte_gateway_test.dart` |
| SC-080-05 | Adapters | Idem |

Aceptación: [`test/acceptance/slice_08_dte_sii.md`](../test/acceptance/slice_08_dte_sii.md).

### 2.3 Adapters en blanco en 12b — clasificación

| ID | Core | Adapters en matriz | Clasificación |
|----|------|--------------------|---------------|
| SC-041-02 | ✅ | — | **Intencional:** caso API; UI cubre SC-041-UI-03 |
| SC-051-02 | ✅ | — | **Intencional:** retry vía core + UI cola |
| SC-003-01 | ✅ | — | **Aceptable:** estado certificado sin persistencia drift dedicada en MVP |

### 2.4 Drift documental corregido

- `docs/reporte-avances-mvp.md` §4.2 decía **24** tests app; valor correcto **27** (incl. SII assist).

---

## 3. Cobertura `packages/core` (RNF-030)

Comando (Windows):

```powershell
cd packages\core
dart test --coverage=coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.dart_tool/package_config.json --report-on=lib
```

| Métrica | Valor [OBSERVADO 2026-11-19] |
|---------|------------------------------|
| Cobertura de líneas en `lib/` | **81,2 %** (1164 / 1434 líneas instrumentadas) |
| Umbral RNF-030 | ≥ 80 % |

### 3.1 Archivos con menor cobertura (no bloquean gate)

| Archivo | Cobertura aprox. | Comentario |
|---------|------------------|------------|
| `lib/domain/dte_status.dart` | 0 % | Enums / ramas poco ejercitadas en unit |
| `lib/scanner/scanner_ble_constants.dart` | 0 % | Constantes; lógica en codec testeada |
| `lib/domain/chile_datetime_format.dart` | 0 % | Usado más en app que en core tests |
| `lib/application/ports/trusted_clock.dart` | ~29 % | Puerto; implementaciones fake en tests |

### 3.2 Propuesta de gate CI (no activado)

**Recomendación:** activar en un slice de infra **después** de merge a `main` o con OK explícito del operador (evita bloquear la rama larga por regresión marginal).

Pasos propuestos:

1. Añadir `scripts/coverage-core.ps1` (espejo de CI) que falle si líneas &lt; 80 %.
2. Paso opcional en `.github/workflows/ci.yml` tras `dart test`.
3. Excluir `coverage/` en Git (artefacto local).

**Estado SLICE-36:** solo documentación; **sin** cambio en workflow.

---

## 4. Recomendación — próximo slice de producto

Criterio: prioridad **negocio**, no “más tests por inercia”.

### 4.1 Recomendación primaria

**Operación SC-080-03 (piloto cert SII real)** — slice operativo, poco o ningún código.

| Prerequisito operador | Acción |
|-----------------------|--------|
| Certificado vigente en dispositivo piloto | Seguir [`runbooks/sii-piloto-indice.md`](../runbooks/sii-piloto-indice.md) |
| Venta de prueba en ambiente cert | Copiar `sale_id` (SLICE-35) y completar [`sii-cert-pilot-evidence.md`](../runbooks/sii-cert-pilot-evidence.md) |
| Evidencia | Estado **CERRADO** con folio / `sale_id` |

**Motivo:** único pendiente **alta** que desbloquea el relato RF-003 / SLICE-8 DoD; la automatización ya cubre replay/live timeout/rechazo (adapters) y asistencia UI.

### 4.2 Alternativa

**SLICE-37 — Ejecutar PR MVP (SC-030-01)** si antes tienes `git remote add origin` + `gh auth login`.

| Prerequisito | Acción |
|--------------|--------|
| Remoto GitHub | [`runbooks/github-remote-setup.md`](../runbooks/github-remote-setup.md) |
| PR | Push + `gh pr create` título alineado slices **0–36**; actualizar `pr-merge-evidence.md` |

**Motivo:** no desbloquea certificación, pero integra código en `main` y valida CI remoto.

### 4.3 Descartado / baja prioridad (salvo pedido)

- **SC-011-BLE-01:** hardware; companion con 1 test verde fuera de CI.
- **SLICE-9** terminal pago: explícitamente post-MVP.
- **Mini-slice cobertura P0:** no requerido antes de SII (baseline **≥ 80 %**).
- **Ampliar 12b con SC-080-01…05:** deuda documental; puede ir en slice de mantenimiento paralelo al piloto.

---

## 5. Definition of Done — SLICE-36

- [x] Baseline suites y tiempos registrados
- [x] Trazabilidad y huecos documentados
- [x] Cobertura core medida + propuesta gate
- [x] Recomendación primaria + alternativa
- [x] Runbook evidencia y acceptance slice_36