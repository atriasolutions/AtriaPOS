# SLICE-1 — Catálogo (RF-010, RF-011 / API-001)

## Feature: Producto en tienda

### SC-010-01 — Crear producto válido

```gherkin
Dado una tienda "t1"
Cuando se crea producto "Pan hallulla" precio 500 con stock inicial 20
Entonces el producto existe con stock 20
```

### SC-010-02 — Precio inválido

```gherkin
Cuando se crea producto con precio 0
Entonces falla con código VALIDACION
```

### SC-010-03 — Barcode duplicado

```gherkin
Dado un producto con barcode "7801234567890"
Cuando se crea otro producto con el mismo barcode en la misma tienda
Entonces falla con código CONFLICTO
```

### SC-011-01 — Búsqueda por texto

```gherkin
Dado productos "Pan hallulla" y "Coca-Cola 1.5L"
Cuando se busca "hall"
Entonces se lista "Pan hallulla"
```

### SC-011-02 — Búsqueda por barcode

```gherkin
Dado producto con barcode "7801234567890"
Cuando se busca "7801234567890"
Entonces se encuentra ese producto
```

Tests Dart: `packages/core/test/application/*`, `packages/core/test/api/*`.