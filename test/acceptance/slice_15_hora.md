# SLICE-15 — Hora SHOA

## SC-040-03 — Apertura registra hora

```gherkin
Cuando abro turno
Entonces respuesta incluye openedAt y UI muestra hora
```

## SC-041-03 — Cierre muestra apertura y cierre

```gherkin
Cuando cierro caja
Entonces diálogo muestra openedAt y closedAt
```

## SC-031-03 — Venta muestra fecha emisión

```gherkin
Cuando confirmo venta
Entonces diálogo muestra createdAt y estado DTE
```

## SC-015-UI-01 — Reloj visible

```gherkin
Given cualquier pantalla
Then esquina muestra hora (pos_clock_label)
```