# SLICE-99 — QR POS + arranque servidor

## Escenarios

### SC-099-01 QR vender
Dado POS con companion LAN en Windows  
Cuando preparo QR modo VENDER  
Entonces servidor activo y URL contiene `mode=VENDER` y `pairingCode`

### SC-099-UI
UI: claves `companion_qr_vender`, `companion_qr_receipt`, `companion_qr_count` en pantallas vender/ingreso/conteo

## Automatización
`apps/pos_app/test/companion_lan_e2e_test.dart` (SC-099-01)