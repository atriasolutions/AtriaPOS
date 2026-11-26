# SLICE-116 — Companion Android LAN

## Decisión

DEC-063. App Flutter en `scanner_companion`. Mismo contrato LAN. Sin CA en el teléfono.

## Escenarios de las slices siguientes

### SC-117-01
`https://10.165.87.116:8765/c/A7K9M2` entrega host, puerto y código.

### SC-117-02
Un enlace cuyo path no es `/c/{codigo}` se rechaza.

### SC-118-01
Con un `Location` válido, el cliente hace pair y abre el WebSocket.

### SC-118-02
Si el enlace corto no resuelve, no se abre el WebSocket.

### SC-118-03
`sendScan` envía `{"type":"scan","code":"..."}`.

### SC-119-01
Al pegar el enlace y conectar, la pantalla muestra el modo (Vender).

### SC-119-02
Si el enlace no sirve, se ve el error y no hay sesión.

### SC-120-01
Dos lecturas iguales sin pulsar Escanear no envían (SLICE-131).

### SC-120-02
Dos códigos distintos sin pulsar Escanear no envían (SLICE-131).

### SC-121-01
Contra `CompanionLanServer` en loopback, un scan llega al stream del servidor.

## Manual

Runbook `runbooks/companion-android-apk.md` (SLICE-121).
