# SLICE-11 — Operación diaria en UI (RF-041, RF-051, RF-021)

**API:** API-003, API-004, API-005. **Permisos:** `cerrarCaja`, `ajustarInventario`; cola DTE supervisor/dueño (gating UI).

## SC-041-UI-01 — Cierre de caja con venta efectivo

```gherkin
Given supervisor con turno abierto fondo 50000
And venta efectivo $1000 sin vuelto
When cierra caja contando 51000 CLP
Then la UI muestra reporte con diferencia 0 y total ventas 1000
And navega a pantalla abrir turno
```

## SC-041-UI-02 — Cajero sin cierre

```gherkin
Given cajero en pantalla vender
Then no ve acción cerrar caja en el menú operación
```

## SC-051-UI-01 — Cola DTE y reintento

```gherkin
Given DTE en modo fallo al checkout
When supervisor abre cola DTE
Then ve la venta pendiente
When toca Reintentar con gateway que emite en segundo intento
Then snackbar indica procesadas y la cola queda vacía
```

## SC-021-UI-01 — Merma desde UI

```gherkin
Given producto "Leche" stock 10
When supervisor busca "Lec" y ajusta delta -1 motivo MERMA
Then la UI confirma stock 9
```