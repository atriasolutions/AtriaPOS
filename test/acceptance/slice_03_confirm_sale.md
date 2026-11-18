# SLICE-3 — Carro y venta (RF-030, RF-031 parcial / API-002)

## Feature: Carro

### SC-030-01 — Crear carro vacío

```gherkin
Dado la tienda "t1"
Cuando se crea un carro
Entonces el carro no tiene líneas
```

### SC-030-02 — Agregar línea y total

```gherkin
Dado producto "Pan" precio 500
Cuando se agregan 2 unidades al carro
Entonces el total del carro es 1000
```

### SC-030-03 — Cambiar cantidad y quitar línea

```gherkin
Dado una línea con cantidad 2
Cuando se actualiza cantidad a 1
Entonces el total se recalcula
Cuando se quita la línea
Entonces el carro queda vacío
```

## Feature: Confirmar venta (sin DTE)

### SC-031-01 — Checkout efectivo exacto

```gherkin
Dado carro con 2× Pan a 500 y stock 10
Cuando checkout con EFECTIVO 1000 y changeClp 0
Entonces venta total 1000 y stock Pan queda 8
```

### SC-031-02 — Carro vacío

```gherkin
Cuando checkout en carro sin líneas
Entonces VALIDACION
```

### SC-031-03 — Stock insuficiente

```gherkin
Dado producto stock 1 bloqueo activo y cantidad 2 en carro
Cuando checkout
Entonces STOCK_INSUFICIENTE
```

### SC-031-04 — Pago insuficiente

```gherkin
Dado total 1000
Cuando pagos suman 500
Entonces VALIDACION
```

Tests: `packages/core/test/application/*`, `packages/core/test/api/sale_service_test.dart`.