# SLICE-18 — BLE GATT

## SC-011-BLE-02 Codec payload

Dado texto escaneado válido  
Cuando `encodeScanPayload` / `decodeScanPayload`  
Entonces respeta trim y límite 512 bytes  

Verificación: `packages/core/test/scanner/scan_payload_codec_test.dart`

## SC-011-BLE-UI-01 UI pareo POS

Dado `BleCentralScannerIngress` inyectado  
Cuando el cajero pulsa **Conectar escáner**  
Entonces se muestra el código con key `scanner_pairing_code`  

Verificación: `apps/pos_app/test/scanner_ble_push_test.dart`

## SC-011-BLE-UI push → carro

Dado `StreamScannerIngress` y producto con `qrPayload`  
Cuando `push(payload)`  
Entonces el carro refleja el producto  

Verificación: `apps/pos_app/test/scanner_ble_push_test.dart`

## SC-011-BLE-01 E2E manual

Dado POS Windows y companion Android pareados  
Cuando se escanea QR de producto  
Entonces el POS agrega al carro si hay match único  

Checklist: `runbooks/ble-scanner-pairing.md`