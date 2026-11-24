# SLICE-63 — Planilla colaboradores (RF-083)

Referencia: [DEC-049](../docs/decisiones/DEC-049-planilla-vs-usuario-pos.md).

## SC-083-01 — Dueño crea colaborador

```gherkin
Dado dueño autenticado
Cuando crea colaborador código V01
Entonces 201 y persiste en planilla
```

## SC-083-02 — Código duplicado

```gherkin
Dado colaborador activo con código V01
Cuando crea otro con V01
Entonces 409 CONFLICTO
```

## SC-083-03 — Supervisor sin permiso

```gherkin
Dado supervisor autenticado
Cuando intenta crear colaborador
Entonces 403 PERMISO_DENEGADO
```

## SC-083-04 — Actualizar datos

```gherkin
Dado colaborador existente
Cuando dueño actualiza apellido
Entonces 200
```

## SC-083-05 — Desactivar

```gherkin
Dado colaborador activo
Cuando dueño desactiva
Entonces active=false y código liberado para otro activo
```

## SC-083-06 — Código inválido

```gherkin
Cuando código contiene ñ o formato inválido
Entonces 400 VALIDACION
```

Tests: `packages/core/test/api/collaborator_*`, `packages/adapters/test/drift_collaborator_*`.