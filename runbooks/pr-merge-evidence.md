# Evidencia — PR MVP hacia `main`

Completar cuando el operador abra o cierre el PR (no commitear tokens ni capturas con secretos).

Runbook merge: [`merge-mvp-hito.md`](merge-mvp-hito.md). Pre-vuelo: [`github-remote-setup.md`](github-remote-setup.md).

## Estado del documento

| Estado | Significado |
|--------|-------------|
| NO_ABIERTO | Kit merge listo; PR no creado aún |
| ABIERTO | PR en GitHub; CI en seguimiento |
| MERGED | Integrado en `main` |

Estado actual: **NO_ABIERTO**

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
| URL del PR | **Pendiente** — pegar en chat tras `gh pr create` |
| Estado global | **NO_ABIERTO** hasta registrar URL abajo |

**Siguiente paso:** operador completa checklist §2–3; agente en turno con URL actualiza tabla “Al abrir PR” y **SC-030-01** en `12b`.

## Al abrir el PR

| Campo | Valor |
|-------|-------|
| Fecha apertura | _(completar)_ |
| Operador | _(completar)_ |
| Rama origen | `feat/slice-0-scaffold` |
| Commit HEAD (`git rev-parse --short HEAD`) | _(completar)_ |
| URL del PR | _(completar)_ |
| Título usado | `MVP POS: slices 0-38` |
| Check **CI** verde en GitHub | ☐ Sí |

## Al mergear

| Campo | Valor |
|-------|-------|
| Fecha merge | _(completar)_ |
| Commit en `main` post-merge | _(completar)_ |
| Tag hito (opcional) | _(ej. mvp-2026-11)_ |

## Notas

- Plantilla cuerpo: [`pr-body-mvp.md`](pr-body-mvp.md).
- Tras merge, seguir [`tienda-piloto-indice.md`](tienda-piloto-indice.md).