# SLICE-58 — Migración org `atriasolutions/AtriaPOS`

## SC-058-01 — DEC y README

```gherkin
Dado SLICE-58 cerrado
Cuando se lee README.md y DEC-046
Entonces el repositorio canónico documentado es atriasolutions/AtriaPOS
```

Verificación: [`README.md`](../../README.md); [`docs/decisiones/DEC-046-repo-org-atriasolutions.md`](../../docs/decisiones/DEC-046-repo-org-atriasolutions.md).

## SC-058-02 — Runbook corte org

```gherkin
Dado operador migra remoto
Cuando abre runbooks/repo-migracion-atria-pos.md sección SLICE-58
Entonces incluye URL atriasolutions/AtriaPOS y checklist PCs
```

## SC-058-03 — Acta canónica

```gherkin
Dado corte org completado
Cuando se lee docs/19-revision-progreso-20251120.md Repositorio canónico
Entonces la fila Repo apunta a atriasolutions/AtriaPOS
Y se menciona remoto intermedio archivado sin reescribir PRs históricos
```

Verificación: [`docs/19-revision-progreso-20251120.md`](../../docs/19-revision-progreso-20251120.md).