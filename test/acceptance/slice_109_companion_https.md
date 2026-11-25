# SLICE-109 — Companion LAN HTTPS y CA

## Escenarios

### SC-109-01 CA persistida
Dado directorio de datos del POS  
Cuando se crea la CA dos veces  
Entonces el PEM de la CA es el mismo

### SC-109-02 certificado servidor
Dado IP anunciada  
Entonces el certificado de servidor TLS es emitido y persistido por IP

### SC-109-03 descarga CA
Dado servidor HTTPS  
Entonces `GET /companion/atria-ca.pem` devuelve PEM instalable

### SC-109-04 health HTTPS
Dado servidor con TLS  
Entonces `GET /health` responde 200

### SC-109-05 redirect corto en HTTPS
Dado oferta válida  
Entonces `GET /c/{code}` responde 302 hacia `/companion/?…`

### SC-109-06 IP activa
Dado interfaces de red  
Entonces RNDIS/USB tether puntúa mayor que VMware

### SC-109-07 QR HTTPS
Dado base `https://host:8765`  
Entonces URL del QR usa esquema HTTPS

## Automatización

`packages/adapters/test/companion_lan_*`, `apps/pos_app/test/companion_lan_config_test.dart`, core SC-109-07

## Piloto manual

Ver `runbooks/companion-lan-install-ca.md`

## Fuera de alcance

Cámara PWA (110), PKIX leaf firmado por CA (mejora futura si el navegador lo exige).