# SLICE-51 — Acta y backlog (piloto BLE diferido)

Documenta estado real sin cerrar SC-011-BLE-01 en hardware.

## SC-051-01 — HEAD main y SLICE-49

```gherkin
Dado SLICE-51 cerrado
Cuando se lee acta §1 y pr-merge-evidence
Entonces origin/main es 2f10165 o posterior
Y PR #8 MERGED está registrado
```

Verificación: [`docs/19-revision-progreso-20251120.md`](../../docs/19-revision-progreso-20251120.md); [`runbooks/pr-merge-evidence.md`](../../runbooks/pr-merge-evidence.md).

## SC-051-02 — SLICE-50 no cerrado falsamente

```gherkin
Dado que el piloto hardware fue pospuesto
Cuando se consulta acta §2 y ble-scanner-pilot-evidence.md
Entonces SLICE-50 figura ABIERTO
Y el estado de evidencia sigue PREPARADO
```

Verificación: acta §2; [`runbooks/ble-scanner-pilot-evidence.md`](../../runbooks/ble-scanner-pilot-evidence.md).

## SC-051-03 — Backlog §8

```gherkin
Dado acta publicada con revisión SLICE-51
Cuando se lee acta §8
Entonces SLICE-50 ABIERTO y SLICE-52 propuesto están explícitos
Y reporte §5 alinea SLICE-50 ABIERTO
```

Verificación: acta §8; [`docs/reporte-avances-mvp.md`](../../docs/reporte-avances-mvp.md) §5.