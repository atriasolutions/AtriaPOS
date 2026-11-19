# SLICE-40 — Cierre PR operador (SC-030-01)

El operador abre el PR; el agente cierra evidencia cuando recibe la URL.

## SC-040-00 — Handoff operador

```gherkin
Dado el kit merge con título MVP POS slices 0-38
Cuando el operador ejecuta push y gh pr create en su terminal
Y comunica la URL del PR al agente
Entonces el agente puede cerrar SC-030-01 sin gh auth interactivo
```

Verificación: [`runbooks/slice-40-operador-pr-checklist.md`](../../runbooks/slice-40-operador-pr-checklist.md).

## SC-030-01 — PR abierto

```gherkin
Dado una URL de PR válida hacia main
Cuando se actualiza pr-merge-evidence.md
Entonces el estado del documento es ABIERTO y SC-030-01 figura cubierto en 12b
```

## SC-040-01 — Sin merge automático

```gherkin
Dado el PR abierto
Cuando no se solicita merge explícito
Entonces el estado no es MERGED
```