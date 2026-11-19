# Evidencia — PR MVP hacia `main`

Completar cuando el operador abra o cierre el PR (no commitear tokens ni capturas con secretos).

Runbook merge: [`merge-mvp-hito.md`](merge-mvp-hito.md).

## Estado del documento

| Estado | Significado |
|--------|-------------|
| NO_ABIERTO | Kit merge listo; PR no creado aún |
| ABIERTO | PR en GitHub; CI en seguimiento |
| MERGED | Integrado en `main` |

Estado actual: **NO_ABIERTO** _(operador actualiza al avanzar)_

## Al abrir el PR

| Campo | Valor |
|-------|-------|
| Fecha apertura | _(completar)_ |
| Operador | _(completar)_ |
| Rama origen | _(ej. feat/slice-0-scaffold)_ |
| Commit HEAD (`git rev-parse --short HEAD`) | _(completar)_ |
| URL del PR | _(completar)_ |
| Título usado | `MVP POS: slices 0-28` |
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