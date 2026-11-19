# SLICE-41 — Registrar PR abierto (SC-030-01)

Registro documental cuando el operador ya abrió el PR y entrega la URL al agente.

## SC-041-00 — Gate URL

```gherkin
Dado el plan SLICE-41 con PR ya abierto por el operador
Cuando el operador pega la URL del PR en el chat de implementación
Entonces el agente puede cerrar evidencia sin gh auth interactivo
```

Si no hay URL en el chat: no marcar SC-030-01 ni estado ABIERTO.

## SC-030-01 — PR abierto

```gherkin
Dado una URL válida de pull request hacia main
Cuando se actualiza pr-merge-evidence.md
Entonces el estado del documento es ABIERTO
Y SC-030-01 figura cubierto en 12b con la URL en nota manual
```

## SC-041-01 — Sin merge automático

```gherkin
Dado el PR registrado en ABIERTO
Cuando no se solicita merge explícito
Entonces el estado no es MERGED
```