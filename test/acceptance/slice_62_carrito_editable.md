# SLICE-62 — Carrito editable (RF-082 / API-002)

Referencia: RF-081 (DEC-048), RF-030.

## SC-082-01 — Cajero actualiza cantidad

```gherkin
Dado cajero autenticado con turno abierto
Y carro con línea cantidad 2
Cuando PATCH cantidad a 1
Entonces 200 y total recalculado
```

## SC-082-02 — Cajero elimina línea

```gherkin
Dado cajero autenticado
Y carro con una línea
Cuando DELETE la línea
Entonces 204 y carro sin líneas
```

## SC-082-03 — Roles de venta heredan editar

```gherkin
Dado rol supervisor o dueño autenticado
Cuando actualiza o elimina línea del carro
Entonces 200 o 204 según operación
```

## SC-082-04 — Sin sesión

```gherkin
Dado sin sesión activa
Cuando updateLine o removeLine
Entonces 401
```

## SC-082-05 — Cantidad inválida

```gherkin
Dado línea en carro
Cuando actualiza cantidad a 0 o negativa
Entonces 400 VALIDACION
```

Tests: `packages/core/test/api/cart_auth_test.dart`, `cart_lines_test.dart`.