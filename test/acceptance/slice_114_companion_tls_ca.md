# SLICE-114 — TLS con IP del QR + onboarding CA

## Escenarios

### SC-114-01
Dado override de host (COMPANION_LAN_HOST o hook de test)  
Cuando `resolveAdvertisedHostSync`  
Entonces devuelve esa IPv4.

### SC-114-02
Dado candidatos RNDIS y VMware sin override  
Cuando `pickAdvertisedHostIpv4`  
Entonces gana la IP del adaptador RNDIS.

### SC-114-03
Dado certificado emitido para IP A  
Cuando se pide material para IP B  
Entonces se regenera el cert y `server-ip.txt` = B.

### SC-114-04
Dado POS HTTPS con PWA válida  
Cuando `prepareCompanionQr`  
Entonces `caInstallUrl` contiene `/companion/instalar-certificado`.

### SC-114-05
Dado diálogo con hint CA  
Entonces existe clave `companion_ca_install_hint`.

## Manual

Certificado se emite al arranque con la IPv4 anunciada. Si cambia la red, reiniciar el POS o fijar `COMPANION_LAN_HOST`; el diálogo muestra `companion_cert_ip_mismatch` si la IP del QR ≠ IP del cert guardado.