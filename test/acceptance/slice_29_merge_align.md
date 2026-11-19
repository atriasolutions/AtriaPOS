# SLICE-29 — Alineación kit merge post-28

Documentación; sin push/merge en el slice.

## SC-029-01 — Comando y título PR

```gherkin
Dado el kit merge actualizado
Cuando el operador consulta runbooks/merge-mvp-hito.md
Entonces el ejemplo gh pr create usa título "MVP POS: slices 0-28" y --body-file runbooks/pr-body-mvp.md
```

Verificación: `runbooks/merge-mvp-hito.md`.

## SC-029-02 — Evidencia PR

```gherkin
Dado la preparación de integración a main
Cuando se abre o mergea un PR
Entonces existe runbooks/pr-merge-evidence.md con estados NO_ABIERTO/ABIERTO/MERGED enlazado desde merge-mvp-hito y tienda-piloto-indice
```

Verificación: `runbooks/pr-merge-evidence.md`, enlaces en `merge-mvp-hito.md`, `tienda-piloto-indice.md`, `pr-body-mvp.md`.