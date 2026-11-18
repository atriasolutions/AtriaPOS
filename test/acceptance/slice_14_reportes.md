# SLICE-14 — Reportes (RF-060 / API-008)

Nota: **SC-060-01** es el smoke de venta en UI (`slice_06_pos_ui.md`).

## SC-060-02 — Totales del día excluyen anuladas

```gherkin
Dado dos ventas confirmadas $1000 y $1500 y una anulada $500 el mismo día
Cuando consulto reporte diario de esa fecha
Entonces salesTotalClp 2500, transactionCount 2, averageTicketClp 1250
```

## SC-060-UI-01 — Reporte en app

```gherkin
Given supervisor con ventas del día
When abre Ventas del día en menú operación
Then ve total, cantidad y ticket promedio
```