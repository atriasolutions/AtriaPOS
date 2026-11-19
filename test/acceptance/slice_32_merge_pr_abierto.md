# SLICE-32 — Ejecutar integración PR (cierre SC-030)

Tercer intento operativo. Requiere [`runbooks/github-remote-setup.md`](../runbooks/github-remote-setup.md).

## SC-032-00 — Pre-vuelo SLICE-32

```gherkin
Dado intentos SLICE-30 y SLICE-31 en pr-merge-evidence.md
Cuando el operador valida gh auth status y git remote -v
Entonces puede publicar la rama y abrir el PR
```

## SC-030-01 — PR abierto

```gherkin
Dado ci-local.ps1 verde y remoto configurado
Cuando se ejecutan push y gh pr create con título MVP POS slices 0-31
Entonces existe un PR en GitHub y la URL figura en pr-merge-evidence.md
```

Verificación: estado **ABIERTO** y URL en `runbooks/pr-merge-evidence.md`.

## SC-030-02 — Evidencia trazable

```gherkin
Dado el PR creado
Cuando se consulta pr-merge-evidence.md
Entonces estado ABIERTO, rama feat/slice-0-scaffold y HEAD registrados
```

## SC-032-01 — Sin merge automático

```gherkin
Dado el PR abierto
Cuando el agente u operador no solicita merge explícito
Entonces el estado no pasa a MERGED sin evidencia de merge
```

_Notas SLICE-32:_ si auth/remoto fallan, bloque «Intento SLICE-32» y SC-030-01 ⬜ en `12b`.