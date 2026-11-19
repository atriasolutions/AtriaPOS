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

## Al abrir el PR

| Campo | Valor |
|-------|-------|
| Fecha apertura | _(completar)_ |
| Operador | _(completar)_ |
| Rama origen | `feat/slice-0-scaffold` |
| Commit HEAD (`git rev-parse --short HEAD`) | _(completar)_ |
| URL del PR | _(completar)_ |
| Título usado | `MVP POS: slices 0-30` |
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