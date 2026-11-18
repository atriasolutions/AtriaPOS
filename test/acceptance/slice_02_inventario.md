# SLICE-2 — Inventario (RF-020, RF-021 / API-004)

## Feature: Consultar stock

### SC-020-01 — Stock de producto existente

```gherkin
Dado un producto con stock 20 en la tienda "t1"
Cuando se consulta el stock de ese producto
Entonces la respuesta indica stock 20
```

### SC-020-02 — Producto inexistente

```gherkin
Cuando se consulta stock de un id desconocido
Entonces falla con código NO_ENCONTRADO
```

## Feature: Ajuste y merma

### SC-021-01 — Merma decrementa stock y audita

```gherkin
Dado producto con stock 20
Cuando se registra ajuste delta -3 motivo MERMA
Entonces stock queda 17 y existe un movimiento auditado
```

### SC-021-02 — Stock resultante negativo

```gherkin
Dado producto con stock 2
Cuando se registra ajuste delta -5 motivo MERMA
Entonces falla con código VALIDACION y stock sigue 2
```

### SC-021-03 — Delta o motivo inválido

```gherkin
Cuando delta es 0 o el motivo no es válido
Entonces falla con código VALIDACION
```

Tests Dart: `packages/core/test/application/*`, `packages/core/test/api/inventory_service_test.dart`.