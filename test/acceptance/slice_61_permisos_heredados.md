# SLICE-61 — Permisos heredados (RF-081)

Referencia: [`docs/decisiones/DEC-048-permisos-herencia-atria-pos.md`](../docs/decisiones/DEC-048-permisos-herencia-atria-pos.md).

## SC-081-01 — Cajero base

```gherkin
Dado rol CAJERO en plantilla Atria POS
Entonces permite vender y consultar stock
Y no permite consultar reportes
```

## SC-081-02 — Jefe de turno hereda venta

```gherkin
Dado rol SUPERVISOR
Entonces hereda vender del cajero
Y permite consultar auditoría
```

## SC-081-03 — Jefe de tienda

```gherkin
Dado rol DUENO
Entonces hereda permisos de supervisor
Y permite gestionar usuarios
```

## SC-081-04 — Cajero sin reportes

```gherkin
Dado cajero autenticado
Cuando consulta reporte diario
Entonces PERMISO_DENEGADO 403
```

## SC-081-05 — Supervisor sin usuarios

```gherkin
Dado supervisor autenticado
Cuando crea usuario
Entonces PERMISO_DENEGADO 403
```