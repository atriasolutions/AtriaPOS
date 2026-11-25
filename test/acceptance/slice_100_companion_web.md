# SLICE-100 — PWA companion_web

## Escenarios

### SC-100-01 parse QR
Dado URL `/companion/?storeId&mode&pairingCode`  
Cuando parseo `CompanionLaunchParams`  
Entonces storeId/modo/código correctos

## Automatización
`apps/companion_web/test/companion_client_test.dart`