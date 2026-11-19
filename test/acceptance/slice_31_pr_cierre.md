# SLICE-31 — Cierre integración PR (SC-030)

Reintento de SLICE-30. Requiere remoto GitHub y `gh` autenticado. Ver [`runbooks/github-remote-setup.md`](../runbooks/github-remote-setup.md).

## SC-031-00 — Pre-vuelo repetido

```gherkin
Dado el bloqueo SLICE-30 documentado en pr-merge-evidence.md
Cuando el operador ejecuta gh auth status y git remote -v
Entonces hay sesión gh y origin configurado antes del push
```

Verificación: `runbooks/github-remote-setup.md`, bloque «Intento SLICE-31» en evidencia si falla.

## SC-030-01 — PR abierto (heredado)

```gherkin
Dado ci-local.ps1 verde y remoto configurado
Cuando se ejecutan push y gh pr create con título MVP POS slices 0-30
Entonces existe un PR en GitHub y la URL figura en pr-merge-evidence.md
```

Verificación: `runbooks/pr-merge-evidence.md` estado **ABIERTO** y URL.

## SC-030-02 — Evidencia trazable (heredado)

```gherkin
Dado el PR creado
Cuando se consulta pr-merge-evidence.md
Entonces estado ABIERTO, rama feat/slice-0-scaffold y HEAD registrados
```

Verificación: `runbooks/pr-merge-evidence.md`.

## SC-031-01 — Sin merge automático

```gherkin
Dado el PR abierto
Cuando el operador no solicita merge explícito
Entonces el estado en pr-merge-evidence.md permanece ABIERTO y no MERGED
```

_Notas SLICE-31:_ si auth/remoto pendiente, estado **NO_ABIERTO** y SC-030-01 sigue ⬜ en matriz `12b`.