# SLICE-97–98 — Servidor HTTP + WebSocket

## Escenarios

### SC-097-01 health
Dado servidor LAN en loopback  
Cuando GET `/health`  
Entonces JSON `ok: true`

### SC-097-02 estáticos
Cuando GET `/companion/`  
Entonces 200 HTML companion

### SC-098-01 pair + WS scan
Cuando POST pair y envío WS `{type: scan, code}`  
Entonces el stream de scans del servidor emite el código decodificado

## Automatización
`packages/adapters/test/companion_lan_server_test.dart`