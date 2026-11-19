# SLICE-43 — Alinear `main` post-merge MVP

Cierra pendiente Git de [`19-revision-progreso-20251119.md`](../../docs/19-revision-progreso-20251119.md) §6.1.

## SC-043-00 — PR docs a main

```gherkin
Dado origin/main en el commit de merge del MVP (PR #1)
Cuando se publica la acta de revisión y evidencia MERGED en main
Entonces origin/main incluye docs/19-revision-progreso-20251119.md
```

PR #2 MERGED: https://github.com/mmb21894-ux/pos-barrio-segmento-d/pull/2 — `main` `6032997`.

## SC-043-01 — Rama de trabajo futura

```gherkin
Dado SLICE-43 cerrado
Cuando un desarrollador inicia un slice nuevo
Entonces trabaja desde main actualizado (git pull) y feat/slice-N desde main
```

## SC-043-02 — Backlog no bloqueante

```gherkin
Dado SLICE-43 documental
Cuando se consulta plan 10 y acta §8
Entonces SLICE-9 y SII prod figuran N/A hasta nuevo slice
Y BLE / Gate 2 / tag están en backlog
```