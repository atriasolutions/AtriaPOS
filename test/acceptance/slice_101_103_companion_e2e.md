# SLICE-101–103 — E2E companion LAN

## Escenarios

### SC-101-01 vender
Cuando pair VENDER y scan por WS  
Entonces `scannerIngress` recibe el código

### SC-102-01 ingreso
Cuando pair RECEIPT_SCAN y scan  
Entonces ingress recibe código (pantalla ingreso escucha el mismo canal)

### SC-103-01 conteo
Cuando pair COUNT_SCAN y scan  
Entonces ingress recibe código

## Automatización
`apps/pos_app/test/companion_lan_e2e_test.dart`