# SLICE-111 — Estado celular conectado en POS

## Escenarios

### SC-111-01 sin sesión
Dado tienda sin emparejamiento  
Entonces estado LAN `none`

### SC-111-02 emparejado sin WS
Dado pair HTTP exitoso sin WebSocket  
Entonces fase `sessionOnly`

### SC-111-03 WebSocket vivo
Dado WS abierto con token válido  
Entonces fase `live`

### SC-111-04 desconectar desde POS
Dado sesión activa  
Cuando cortar sesión  
Entonces token eliminado y sockets cerrados

### SC-111-05 token inválido en WS
Dado token inexistente  
Entonces no se registra conexión live

### SC-111-06 etiquetas UI
Dado fase y modo  
Entonces textos en español caja (chip y diálogo QR)

### SC-111-07 e2e estado live
Dado composición POS + pair + WS  
Entonces `fetchCompanionLanStatus` es `live`

### SC-111-08 e2e disconnect
Dado sesión live  
Cuando `disconnectCompanionLan`  
Entonces escaneos posteriores no llegan al ingress

### SC-111-09 regresión
Dado nuevo pair  
Entonces revoca token anterior (SC-096-03)

## Automatización

`packages/core/test/application/*companion_lan*`, `packages/adapters/test/companion_lan_server_test.dart`, `apps/pos_app/test/companion_lan_*`

## Fuera de alcance

E2E piloto triple flujo (SLICE-112).