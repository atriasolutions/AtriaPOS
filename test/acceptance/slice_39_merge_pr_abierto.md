# SLICE-39 — Ejecutar integración PR (cierre SC-030)

Sexto intento con kit título **0-38**. Pre-vuelo: [`runbooks/github-remote-setup.md`](../runbooks/github-remote-setup.md).

## SC-039-00 — Pre-vuelo

```gherkin
Dado los intentos SLICE-30 a SLICE-38 en pr-merge-evidence.md
Y ci-local.ps1 verde (114 + 25 + 27)
Cuando gh auth status y git remote -v son válidos en la máquina del operador
Entonces el operador puede publicar la rama y crear el PR
```

## SC-030-01 — PR abierto

```gherkin
Dado ci-local.ps1 verde y remoto origin configurado
Cuando se ejecutan push y gh pr create con título MVP POS slices 0-38
Entonces la URL figura en pr-merge-evidence.md en estado ABIERTO
```

## SC-030-02 — Evidencia trazable

```gherkin
Dado el PR creado
Cuando se consulta pr-merge-evidence.md
Entonces HEAD y rama feat/slice-0-scaffold están registrados
```

## SC-039-01 — Sin merge automático

```gherkin
Dado el PR abierto
Cuando no se solicita merge explícito
Entonces el estado no es MERGED
```