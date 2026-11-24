# SLICE-78 — Entradas credenciales y RUT

## SC-078-01 — Usuario sin mensaje «sin ñ»

```gherkin
Dado el formulario de usuario
Cuando el operador escribe ñ en el campo username
Entonces la UI muestra n sin advertencia de «sin ñ»
```

Verificación: `credential_policy_test`, `atria_text_formatters.dart`, `store_setup_screen`, `user_create_screen`.

## SC-078-02 — RUT sin puntos con guión

```gherkin
Dado el alta de tienda o usuario
Cuando ingresa RUT sin puntos
Entonces el campo muestra guión antes del dígito verificador
```

Verificación: `rut_chile_test`, `RutChileEntryFormatter`.