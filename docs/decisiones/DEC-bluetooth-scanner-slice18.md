# DEC — BLE GATT slice 18 (cierre RNF-041)

## Spike (día 0)

| Plataforma | Rol | Paquete | Resultado |
|------------|-----|---------|-----------|
| POS Windows | Central BLE | `flutter_blue_plus` 1.x en `pos_app` | Scan por servicio UUID + nombre `POS-Barrio-{code}`; NOTIFY en characteristic |
| Companion Android | Periférico GATT | `flutter_ble_peripheral` 3.x | `AndroidAdvertiseData` + `GattServerSettings`; `sendData` tras lectura QR |

**Plan B:** si el stack Windows falla en campo, mantener escaneo manual en búsqueda; tests/CI usan siempre `StreamScannerIngress`.

## Diseño

| Tema | Decisión |
|------|----------|
| Pareo | POS genera código 4 dígitos; companion lo ingresa y anuncia `POS-Barrio-{código}` |
| Payload | UTF-8, trim, máx 512 B (`scan_payload_codec`) |
| Match carro | 1 resultado → `addLine`; 0 → SnackBar; N>1 → solo búsqueda |
| Debounce | 300 ms mismo payload en `BleCentralScannerIngress` |