# SLICE-60 — Perfil usuario (RF-080)

Referencia: [`docs/decisiones/DEC-047-credenciales-username-pin.md`](../docs/decisiones/DEC-047-credenciales-username-pin.md).

## SC-080-01 — Login username + PIN

```gherkin
Dado usuario cajero con username usr_cajero
Cuando login con username y PIN correctos
Entonces sesión CAJERO activa
```

## SC-080-02 — Username con ñ

```gherkin
Cuando crea usuario con username cañero
Entonces VALIDACION
```

## SC-080-03 — PIN con ñ

```gherkin
Cuando PIN contiene ñ
Entonces VALIDACION
```

## SC-080-04 — UUID al crear

```gherkin
Dado dueño autenticado
Cuando crea usuario válido
Entonces respuesta incluye id UUID distinto del username
```

## SC-080-05 — Username duplicado

```gherkin
Cuando username ya existe en la tienda
Entonces CONFLICTO
```

## SC-080-06 — Drift username

```gherkin
Cuando usuario persistido con username
Entonces findByUsername lo recupera
```

## SC-080-07 — RUT inválido

```gherkin
Cuando RUT persona inválido en alta
Entonces VALIDACION
```