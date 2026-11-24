# Evidencia — PR MVP hacia `main`

Completar cuando el operador abra o cierre el PR (no commitear tokens ni capturas con secretos).

Runbook merge: [`merge-mvp-hito.md`](merge-mvp-hito.md). Pre-vuelo: [`github-remote-setup.md`](github-remote-setup.md).

## Estado del documento

| Estado | Significado |
|--------|-------------|
| NO_ABIERTO | Kit merge listo; PR no creado aún |
| ABIERTO | PR en GitHub; CI en seguimiento |
| MERGED | Integrado en `main` |

Estado actual: **MERGED**

## Intento SLICE-30 (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| `ci-local.ps1` | Verde |
| `git remote` | Sin `origin` configurado |
| `gh auth` | Pendiente (`gh auth login` device) |

**Siguiente paso:** completar [`github-remote-setup.md`](github-remote-setup.md), push y `gh pr create`; actualizar esta tabla a **ABIERTO** con URL.

## Intento SLICE-31 (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| `ci-local.ps1` | Verde (114 + 25 + 26) |
| `git remote` | Sin `origin` configurado |
| `gh auth` | Sin sesión; device login `0A7E-07BB` en https://github.com/login/device |
| `git push` / `gh pr create` | No ejecutados (bloqueante) |

**Siguiente paso:** operador completa auth + remoto; reejecutar push y `gh pr create` (título `MVP POS: slices 0-30`); actualizar estado **ABIERTO** abajo.

## Intento SLICE-32 (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| `ci-local.ps1` | Verde (114 + 25 + 26) |
| `git remote` | Sin `origin` válido (`git push`: fatal origin) |
| `gh auth` | Sin sesión; device `6ED0-659C` en https://github.com/login/device |
| `git push` / `gh pr create` | No ejecutados |

**Siguiente paso:** `gh auth login` + `git remote add origin <url>`; push; `gh pr create` título **`MVP POS: slices 0-31`**; evidencia **ABIERTO**.

## Intento SLICE-34 (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| `ci-local.ps1` | Verde (114 + 25 + 27) |
| `git remote` | Sin `origin` |
| `gh auth` | Sin sesión (`gh auth status` falla) |
| `git push` | No ejecutado (sin remoto) |
| `gh pr create` | No ejecutado |

**Siguiente paso:** operador completa auth en navegador **antes del timeout (~15 min)**; configura `origin`; push; `gh pr create` título **`MVP POS: slices 0-33`**.

## Intento SLICE-38 (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| `ci-local.ps1` | Verde (114 + 25 + 27) |
| `git remote` | Sin `origin` configurado |
| `gh auth` | Sin sesión (`gh auth status`: not logged in) |
| `git push` | Falló: `fatal: 'origin' does not appear to be a git repository` |
| `gh pr create` | No ejecutado |
| HEAD | `18a8314` (commit slice-38 kit) |

**Siguiente paso:** [`github-remote-setup.md`](github-remote-setup.md); `gh auth login`; `git remote add origin <url>`; `git push -u origin HEAD`; `gh pr create` título **`MVP POS: slices 0-37`**; actualizar estado **ABIERTO** abajo.

## Intento SLICE-39 (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| `ci-local.ps1` | Verde (114 + 25 + 27) |
| `git remote` | Sin `origin` en sesión agente |
| `gh auth` | Sin sesión (`gh auth status`: not logged in); `gh auth login` requiere flujo interactivo en terminal del operador |
| `git push` / `gh pr create` | No ejecutados |
| HEAD base | `ed7d78a` (commit slice-39 kit) |

**Siguiente paso:** operador ejecuta en PowerShell local (con gh + origin ya configurados): `git push -u origin HEAD`; `gh pr create --base main --title "MVP POS: slices 0-38" --body-file runbooks/pr-body-mvp.md`; pegar URL y pasar estado **ABIERTO** abajo.

## SLICE-40 — Cierre operador (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| Modelo | Operador abre PR; agente cierra evidencia con URL (sin `gh auth login` en agente) |
| Checklist | [`slice-40-operador-pr-checklist.md`](slice-40-operador-pr-checklist.md) |
| `ci-local.ps1` | Verde (114 + 25 + 27) en HEAD `d5d75ea` |
| URL del PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/1 |
| Estado global | Cerrado por SLICE-41 (registro en tabla abajo) |

**Siguiente paso:** operador completa checklist §2–3; agente en turno con URL actualiza tabla “Al abrir PR” y **SC-030-01** en `12b`.

## SLICE-41 — Registro PR (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| Gate | URL del PR confirmada (evidencia captura / operador) |
| Remoto | `https://github.com/mmb21894-ux/pos-barrio-segmento-d.git` |
| PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/1 |
| HEAD rama feature publicada | `16bc091` (`chore: abrir PR MVP`; MVP en ancestro `3f1ee4f`) |
| Validación | Título **0-38**; base `main` ← head `feat/slice-0-scaffold` |
| Estado global | **MERGED** (SLICE-42 documental 2026-11-19) |

**Siguiente paso:** tag opcional `mvp-2026-11`; ramas futuras desde `main`.

## SLICE-43 — Docs en `main` (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| Commit docs | `5b5339f` (`feat/slice-42)` — acta doc 19 + evidencia MERGED |
| PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/2 |
| PR #2 merge | 2026-11-19 → `main` `6032997` |
| Siguiente | Trabajar desde `main`; tag opcional `mvp-2026-11` |

## Al abrir el PR

| Campo | Valor |
|-------|-------|
| Fecha apertura | 2026-11-19 |
| Operador | mmb21894-ux (local `gh` + cmd) |
| Rama origen | `feat/slice-0-scaffold` |
| Commit HEAD (`git rev-parse --short HEAD`) | `22ddccc` en feature (incl. docs slice-41); ancestro MVP `3f1ee4f` |
| URL del PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/1 |
| Título usado | `MVP POS: slices 0-38` |
| Check **CI** verde en GitHub | ☑ Sí (2026-11-19, CI `test` SUCCESS) |

## SLICE-42 — Merge PR #1 (2026-11-19)

| Resultado | Detalle |
|-----------|---------|
| Merge | Operador en GitHub; `gh pr view 1` → state **MERGED** |
| `mergedAt` | 2026-11-19T20:34:50Z |
| Commit `main` | `20dad83` |
| CI pre-merge | SUCCESS (pull_request + push) |
| Tag | Pendiente decisión |

## Al mergear

| Campo | Valor |
|-------|-------|
| Fecha merge | 2026-11-19 |
| Commit en `main` post-merge | `20dad83` |
| Tag hito (opcional) | **`mvp-2026-11`** → `ddd071e` (SLICE-46, 2026-11-20) |

## SLICE-46 — Slices 44–45 + tag (2026-11-20)

| Resultado | Detalle |
|-----------|---------|
| PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/5 |
| Merge | **MERGED** → `main` `ddd071e` |
| CI PR | `test` SUCCESS |
| Tag | `mvp-2026-11` (anotado, push origin) |
| Contenido | SLICE-44 BLE handoff + SLICE-45 ADRs Gate 2 parcial |
| Siguiente | Piloto BLE CERRADO; Gate 2 completo opcional; ramas desde `main` o tag |

## SLICE-47 — Acta post-tag (2026-11-20)

| Resultado | Detalle |
|-----------|---------|
| `main` HEAD docs | `75a6f6f` (posterior a merge `ddd071e`) |
| Acta vigente | [`docs/19-revision-progreso-20251120.md`](../docs/19-revision-progreso-20251120.md) |
| Acceptance | `test/acceptance/slice_47_acta_post_tag.md` |

## SLICE-47 — PR merge (2026-11-20)

| Resultado | Detalle |
|-----------|---------|
| PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/6 |
| Merge | **MERGED** — commit merge `a2b05c8` |
| CI PR | `test` SUCCESS |
| Contenido | Acta post-tag, reporte, higiene ramas doc |

## SLICE-48 — PR merge (2026-11-20)

| Resultado | Detalle |
|-----------|---------|
| PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/7 |
| Merge | **MERGED** → `main` `c5a1fda` |
| CI PR | `test` SUCCESS (incl. `scanner_companion`) |
| Contenido | CI companion; `ble-piloto-dia-cero.md`; acceptance `slice_48_ble_pre_pilot.md` |
| Tag | `mvp-2026-11` sin mover (`ddd071e`) |

## SLICE-49 — Integración main 47–48 (2026-11-20)

| Resultado | Detalle |
|-----------|---------|
| `origin/main` | `c5a1fda` (merge PR #7; incluye PR #6) |
| `ci-local.ps1` | 114 + 25 + 27 + 1 |
| Acceptance | `test/acceptance/slice_49_integracion_main.md` |
| Siguiente | Piloto BLE hardware (SLICE-50 propuesto); Gate 2 opcional |

## SLICE-49 — PR #8 merge docs (2026-11-20)

| Resultado | Detalle |
|-----------|---------|
| PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/8 |
| Merge | **MERGED** → `main` `2f10165` |
| Contenido | Acta/evidencia SLICE-49 |

## SLICE-58 — Org `atriasolutions/AtriaPOS` (2026-11-24)

| Resultado | Detalle |
|-----------|---------|
| Repo org | https://github.com/atriasolutions/AtriaPOS |
| Mirror | `main` @ `3a32e8c` (código slice `77cb3f4`) + tag `mvp-2026-11` |
| Privado | **Pendiente operador** — `gh repo edit` → 404 sin admin org (repo aún PUBLIC) |
| CI org | Verificar en Actions tras push; `ci-local` verde en `550eafc` |
| PR org | No aplica: mirror directo a `main`; este commit cierra evidencia SLICE-58 |
| Personal intermedio | `mmb21894-ux/atria-pos` — README redirect + **archivado** |
| DEC | [DEC-046-repo-org-atriasolutions.md](../docs/decisiones/DEC-046-repo-org-atriasolutions.md) |

## SLICE-57 — Sin nombres propios (2026-11-24)

| Resultado | Detalle |
|-----------|---------|
| PR | https://github.com/mmb21894-ux/atria-pos/pull/4 |
| Merge | **MERGED** |
| Contenido | DEC-045; `check-no-person-names.ps1`; CI; higiene evidencia/tests |
| `ci-local.ps1` | Verde (gate + 119 core) |

## SLICE-56 — Identidad técnica (2026-11-24)

| Resultado | Detalle |
|-----------|---------|
| PR | https://github.com/mmb21894-ux/atria-pos/pull/2 |
| Merge | **MERGED** en `atria-pos` `main` |
| Contenido | `kAppName`, `atria_pos_core`, BLE `Atria-POS`, `resolveSqlitePath` |
| `ci-local.ps1` | Verde (119 core + suites) |

## SLICE-55 — Marca Atria POS y repo canónico (2026-11-24)

| Resultado | Detalle |
|-----------|---------|
| Repo nuevo | https://github.com/mmb21894-ux/atria-pos |
| PR | https://github.com/mmb21894-ux/atria-pos/pull/1 MERGED |
| Migración | Push `main`, ramas y tag `mvp-2026-11` desde mirror local |
| Repo legado | `pos-barrio-segmento-d` — archivar tras cutover |
| DEC | [DEC-044-marca-atria-pos.md](../docs/decisiones/DEC-044-marca-atria-pos.md) |
| Runbook | [repo-migracion-atria-pos.md](repo-migracion-atria-pos.md) |

## SLICE-52–54 — Revisión 1 piloto (2026-11-24)

| Resultado | Detalle |
|-----------|---------|
| PR | https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/10 |
| Merge | **MERGED** → `main` `248fbbb` |
| Contenido | BLE Windows (52), piloto tienda (53), cierre rev. 1 (54) |
| `ci-local.ps1` | Verde pre-push |
| CI GitHub | `test` pass (PR #10) |
| Fuera de alcance | SLICE-50 piloto BLE; smoke SC-052-03 |

## SLICE-77 — Cierre revisión 2 + push `main` (2026-11-24)

| Resultado | Detalle |
|-----------|---------|
| Modelo | Push directo a `main` (sin PR) |
| Remoto | `origin` → `atriasolutions/AtriaPOS` |
| `ci-local.ps1` | Verde pre-push |
| Commit cierre docs | `dc481e8` feat(slice-77) |
| `origin/main` post-push | `f5eba61` (2026-11-24) |
| Rango R2 en remoto | `317105b` feat(slice-59) … `2fc7594` feat(slice-76) + cierre docs |
| SLICE-50 | **ABIERTO** — piloto BLE manual |

## SLICE-51 — Acta backlog (2026-11-20)

| Resultado | Detalle |
|-----------|---------|
| `origin/main` vigente | `2f10165` |
| SLICE-50 | **ABIERTO** — piloto BLE manual diferido; evidencia PREPARADO |
| Acceptance | `test/acceptance/slice_51_acta_backlog.md` |
| Siguiente | Cerrar SLICE-50 con hardware; o SLICE-52 Gate 2 / feature |

## Higiene de ramas (opcional, confirmar antes de borrar)

Ramas típicamente **ya mergeadas** en remoto; candidatas a borrar local/remoto tras `git fetch --prune`:

- `feat/slice-0-scaffold`
- `docs/slice-43-cierre`
- `feat/slice-44-piloto-ble` / `feat/slice-45-gate2-dec` (si el remoto ya las eliminó post PR #5)

Comandos **solo con confirmación explícita:**

```powershell
git branch -d <rama-local>
git push origin --delete <rama-remota>
```

Trabajo futuro: siempre `git checkout main` → `git pull` → `feat/slice-N-...` desde `main`.

## Notas

- Plantilla cuerpo: [`pr-body-mvp.md`](pr-body-mvp.md).
- Tras merge, seguir [`tienda-piloto-indice.md`](tienda-piloto-indice.md).