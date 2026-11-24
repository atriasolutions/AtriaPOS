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
Entonces documenta URL github.com/mmb21894-ux/atria-pos
Y checklist de alineación de origin en PCs
```

Verificación: [`runbooks/repo-migracion-atria-pos.md`](../../runbooks/repo-migracion-atria-pos.md).

## SC-055-03 — Acta repositorio canónico

```gherkin
Dado migración completada
Cuando se lee docs/19-revision-progreso-20251120.md bloque Repositorio canónico
Entonces apunta a mmb21894-ux/atria-pos
Y mantiene enlaces históricos al repo pos-barrio-segmento-d sin reescribir PRs antiguos
```

Verificación: [`docs/19-revision-progreso-20251120.md`](../../docs/19-revision-progreso-20251120.md).