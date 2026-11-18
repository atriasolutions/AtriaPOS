# SLICE-13 — Catálogo en UI (RF-010, RF-012 / API-001)

## SC-010-UI-01 — Crear producto y vender

```gherkin
Given supervisor en tienda con turno abierto
When crea producto "Yogurt" precio 1200 stock 5
And busca "Yog" en pantalla vender
Then aparece "Yogurt" en resultados
```

## SC-010-UI-02 — Cajero sin alta de producto

```gherkin
Given cajero en pantalla vender
Then no ve "Nuevo producto" en menú operación
```

## SC-010-UI-03 — Precio inválido

```gherkin
When supervisor ingresa precio 0
Then la UI muestra error de validación sin crear producto
```