# SLICE-96 — Emparejamiento companion (1 slot)

## Escenarios

### SC-096-01 oferta y pair válido
Dado un repositorio en memoria  
Cuando creo oferta modo VENDER y emparejo con el mismo modo  
Entonces obtengo token `ctok_*` y wsPath `/v0/ws/companion`

### SC-096-02 modo distinto
Cuando el modo del pair no coincide con la oferta  
Entonces falla con `VALIDACION`

### SC-096-03 revocación
Cuando emparejo un segundo companion  
Entonces el token anterior queda invalidado

## Automatización
`packages/core/test/application/companion_pairing_test.dart`, `companion_api_test.dart`