# SLICE-6 — UI POS mínima

**RF:** RF-030 (carro), RF-040 (apertura turno). **Persistencia:** Drift + carrito in-memory.

## SC-060-01 — Venta completa en UI

```gherkin
Given tienda "tienda_demo" con producto "Pan" a $500 y stock 10
And la app usa base SQLite local
When el cajero abre turno con $0 en efectivo
And busca "Pan" y agrega al carro
And confirma pago efectivo por el total exacto
Then la UI muestra boleta EMITIDA con folio
And el stock de "Pan" queda en 8
```

## SC-060-02 — Sin turno abierto

```gherkin
Given no hay turno abierto
When el cajero entra a vender
Then la app muestra pantalla para abrir turno
```