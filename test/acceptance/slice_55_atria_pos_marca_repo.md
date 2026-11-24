# SLICE-55 — Marca Atria POS y repo canónico (Fase A)

Sin cambios de comportamiento en código producto (Fase B = SLICE-56).

## SC-055-01 — README y DEC

```gherkin
Dado cierre SLICE-55
Cuando se lee README.md en la raíz
Entonces el título principal es Atria POS
Y existe docs/decisiones/DEC-044-marca-atria-pos.md
```

Verificación: [`README.md`](../../README.md); [`docs/decisiones/DEC-044-marca-atria-pos.md`](../../docs/decisiones/DEC-044-marca-atria-pos.md).

## SC-055-02 — Runbook migración

```gherkin
Dado operador prepara remoto nuevo
Cuando abre runbooks/repo-migracion-atria-pos.md
Entonces documenta migración de repos (histórico → org)
Y checklist de alineación de origin en PCs
```

Verificación: [`runbooks/repo-migracion-atria-pos.md`](../../runbooks/repo-migracion-atria-pos.md).

## SC-055-03 — Acta repositorio canónico

```gherkin
Dado migración SLICE-55/58 completada
Cuando se lee docs/19-revision-progreso-20251120.md bloque Repositorio canónico
Entonces el forward canónico está actualizado (DEC-046)
Y mantiene enlaces históricos sin reescribir PRs antiguos
```

Verificación: [`docs/19-revision-progreso-20251120.md`](../../docs/19-revision-progreso-20251120.md).