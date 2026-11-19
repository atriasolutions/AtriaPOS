# SLICE-34 — Ejecutar integración PR (cierre SC-030)

Cuarto intento. Pre-vuelo: [`runbooks/github-remote-setup.md`](../runbooks/github-remote-setup.md).

## SC-034-00 — Pre-vuelo

```gherkin
Dado los intentos SLICE-30 a SLICE-32 en pr-merge-evidence.md
Cuando gh auth status y git remote -v son válidos
Entonces el operador puede publicar la rama
```

## SC-030-01 — PR abierto

```gherkin
Dado ci-local.ps1 verde y remoto configurado
Cuando se ejecutan push y gh pr create con título MVP POS slices 0-33
Entonces la URL figura en pr-merge-evidence.md en estado ABIERTO
```

## SC-030-02 — Evidencia trazable

```gherkin
Dado el PR creado
Cuando se consulta pr-merge-evidence.md
Entonces HEAD y rama feat/slice-0-scaffold están registrados
```

## SC-034-01 — Sin merge automático

```gherkin
Dado el PR abierto
Cuando no se solicita merge explícito
Entonces el estado no es MERGED
```

_Notas SLICE-34:_ si auth/remoto fallan, bloque «Intento SLICE-34»; SC-030-01 ⬜.