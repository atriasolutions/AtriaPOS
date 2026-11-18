# SLICE-4 — Turno y cierre (RF-040, RF-041 / API-003)

### SC-040-01 — Abrir turno

```gherkin
Cuando se abre turno con fondo 50000
Entonces existe turno abierto en la tienda
```

### SC-040-02 — Segundo turno abierto

```gherkin
Dado turno abierto
Cuando se intenta abrir otro turno
Entonces CONFLICTO
```

### SC-041-01 — Cierre con ventas

```gherkin
Dado apertura 50000 y venta efectivo 1000 sin vuelto
Cuando cierre con contado 51000
Entonces expectedCash 51000, salesTotal 1000, difference 0
```

### SC-041-02 — Cierre sin turno abierto

```gherkin
Cuando se cierra turno inexistente o ya cerrado
Entonces error (NO_ENCONTRADO o VALIDACION)
```

### SC-031-05 — Checkout sin turno

```gherkin
Cuando checkout sin turno abierto
Entonces TURNO_CERRADO
```

### SC-031-06 — Checkout con turno (regresión)

```gherkin
Dado turno abierto
Cuando checkout válido
Entonces venta OK
```