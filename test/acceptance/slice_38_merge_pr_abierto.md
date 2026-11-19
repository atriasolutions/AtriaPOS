# SLICE-38 — Ejecutar integración PR (cierre SC-030)

Quinto intento con kit al día (slices 0–37). Pre-vuelo: [`runbooks/github-remote-setup.md`](../runbooks/github-remote-setup.md).

## SC-038-00 — Pre-vuelo

```gherkin
Dado los intentos SLICE-30 a SLICE-34 en pr-merge-evidence.md
Y ci-local.ps1 verde (114 + 25 + 27)
Cuando gh auth status y git remote -v son válidos
Entonces el operador puede publicar la rama
```

## SC-030-01 — PR abierto

```gherkin
Dado ci-local.ps1 verde y remoto configurado
Cuando se ejecutan push y gh pr create con título MVP POS slices 0-37
Entonces la URL figura en pr-merge-evidence.md en estado ABIERTO
```

Verificación: [`runbooks/pr-merge-evidence.md`](../../runbooks/pr-merge-evidence.md). Si falla auth/remoto, estado permanece **NO_ABIERTO**.

## SC-030-02 — Evidencia trazable

```gherkin
Dado el PR creado
Cuando se consulta pr-merge-evidence.md
Entonces HEAD y rama feat/slice-0-scaffold están registrados
```

## SC-038-01 — Sin merge automático

```gherkin
Dado el PR abierto
Cuando no se solicita merge explícito
Entonces el estado no es MERGED
```