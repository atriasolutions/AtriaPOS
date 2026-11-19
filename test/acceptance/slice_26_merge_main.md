# SLICE-26 — Hito merge MVP a `main`

Ejecuta y documenta el kit de PR; no incluye push/merge salvo acción del operador.

## SC-026-01 — Paridad local con CI

```gherkin
Dado el repositorio en la rama de trabajo
Cuando se ejecuta scripts/ci-local.ps1 o los bloques de runbooks/merge-mvp-hito.md
Entonces core, adapters y pos_app terminan en verde con el mismo alcance que .github/workflows/ci.yml
```

Verificación: [`scripts/ci-local.ps1`](../scripts/ci-local.ps1), [`runbooks/merge-mvp-hito.md`](../runbooks/merge-mvp-hito.md).

## SC-026-02 — Kit PR coherente

```gherkin
Dado slices 0–25 cerrados en la rama (SLICE-9 opcional sin iniciar)
Cuando el equipo prepara integración a main
Entonces encuentra runbook actualizado, plantilla runbooks/pr-body-mvp.md y README/reporte con estado listo para PR
```

Verificación: `runbooks/pr-body-mvp.md`, `docs/reporte-avances-mvp.md`, `README.md`.