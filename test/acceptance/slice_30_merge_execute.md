# SLICE-30 — Ejecutar integración PR a `main`

Requiere remoto GitHub y `gh` autenticado. Ver [`runbooks/github-remote-setup.md`](../runbooks/github-remote-setup.md).

## SC-030-00 — Pre-vuelo GitHub

```gherkin
Dado el kit merge listo
Cuando el operador revisa github-remote-setup.md
Entonces encuentra pasos para gh auth y remoto origin antes de push
```

Verificación: `runbooks/github-remote-setup.md`, enlace en `merge-mvp-hito.md`.

## SC-030-01 — PR abierto

```gherkin
Dado ci-local.ps1 verde y remoto configurado
Cuando se ejecutan push y gh pr create
Entonces existe un PR en GitHub y la URL figura en pr-merge-evidence.md
```

Verificación: `runbooks/pr-merge-evidence.md` estado **ABIERTO** y URL.

## SC-030-02 — Evidencia trazable

```gherkin
Dado el PR creado
Cuando se consulta pr-merge-evidence.md
Entonces estado ABIERTO, rama feat/slice-0-scaffold y HEAD registrados
```

Verificación: `runbooks/pr-merge-evidence.md`.

_Notas SLICE-30:_ si auth/remoto pendiente, estado permanece **NO_ABIERTO** con bloque «Intento SLICE-30» en evidencia.