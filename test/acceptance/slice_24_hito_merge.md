# SLICE-24 — Hito integración (prep merge a `main`)

## SC-024-01 — Paridad local con CI

```gherkin
Dado el repositorio en la rama de trabajo
Cuando se ejecutan dart test (core, adapters) y flutter test (pos_app)
Entonces todas las suites terminan en verde con el mismo alcance que .github/workflows/ci.yml
```

Verificación: comandos en [`runbooks/merge-mvp-hito.md`](../runbooks/merge-mvp-hito.md)

## SC-024-02 — Documentación de merge

```gherkin
Dado slices 0–23 cerrados en la rama
Cuando el equipo consulta hito de integración
Entonces encuentra runbook de PR, reporte MVP actualizado y README con estado reciente
```

Verificación: `docs/reporte-avances-mvp.md`, `README.md`, runbook merge.