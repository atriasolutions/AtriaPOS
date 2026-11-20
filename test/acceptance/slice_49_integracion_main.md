# SLICE-49 — Integración `main` post SLICE-47/48

Cierra desalineación entre `origin/main` y acta post-tag. Sin piloto BLE en hardware.

## SC-049-01 — Commits 47/48 en origin/main

```gherkin
Dado PR #6 y PR #7 MERGED en GitHub
Cuando se consulta origin/main
Entonces HEAD es c5a1fda o posterior
Y incluye commits feat(slice-47) y feat(slice-48)
Y CI workflow ejecuta scanner_companion
```

Verificación: `git fetch && git log origin/main -5`; [`.github/workflows/ci.yml`](../../.github/workflows/ci.yml).

## SC-049-02 — Evidencia PR

```gherkin
Dado SLICE-49 cerrado
Cuando se lee pr-merge-evidence.md
Entonces registra PR #6 y #7 como MERGED con URLs y SHAs
Y tag mvp-2026-11 no se movió
```

Verificación: [`runbooks/pr-merge-evidence.md`](../../runbooks/pr-merge-evidence.md) § SLICE-47/48 PR merge.

## SC-049-03 — Acta y reporte

```gherkin
Dado main integrado
Cuando se lee acta 2026-11-20 y reporte-avances-mvp.md
Entonces origin/main y ci-local 114+25+27+1 coinciden con evidencia
Y BLE SC-011-BLE-01 sigue PREPARADO hasta piloto hardware
```

Verificación: [`docs/19-revision-progreso-20251120.md`](../../docs/19-revision-progreso-20251120.md); [`docs/reporte-avances-mvp.md`](../../docs/reporte-avances-mvp.md).

## SC-049-04 — Tag hito intacto

```gherkin
Dado integración SLICE-49 sin nuevo hito
Cuando se inspecciona refs/tags/mvp-2026-11
Entonces apunta al merge PR #5 ddd071e
```

Verificación: `git rev-parse refs/tags/mvp-2026-11^{commit}`; [`test/acceptance/slice_46_mvp_tag.md`](slice_46_mvp_tag.md).