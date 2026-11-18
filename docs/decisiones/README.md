# Registro de decisiones arquitectónicas (ADR)

Cada decisión importante genera un archivo:

```text
docs/decisiones/DEC-NNN-titulo-corto.md
```

## Plantilla

```markdown
# DEC-NNN — Título

- **Estado:** Propuesto | Aceptado | Reemplazado por DEC-XXX
- **Fecha:**
- **Prioridad:** P0 | P1 | P2
- **Relacionado:** RF-xxx, SLICE-x

## Contexto

## Opciones consideradas

| Opción | Pros | Contras |
|--------|------|---------|
| A | | |
| B | | |

## Decisión

## Consecuencias

- Positivas
- Negativas / deuda

## Actualización de docs

- [ ] docs/04
- [ ] docs/06
- [ ] docs/07
- [ ] docs/08
```

## Índice de ADRs

| ADR | Título | Estado |
|-----|--------|--------|
| [DEC-001](DEC-001-monorepo-manual.md) | Monorepo manual | Aceptado |

Al crear un ADR, actualizar esta tabla y la fila correspondiente en [`16-registro-decisiones.md`](../16-registro-decisiones.md).