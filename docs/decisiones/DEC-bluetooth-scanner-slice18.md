# DEC — BLE GATT slice 18 (cierre RNF-041)

## Spike (día 0)

| Plataforma | Rol | Paquete | Resultado |
|------------|-----|---------|-----------|
| POS Windows | Central BLE | `flutter_blue_plus` **1.34.5** + **`flutter_blue_plus_windows` 1.26.x** en `pos_app` | Import wrapper Windows; scan UUID + `companionPairingMatches` (nombre o service data); NOTIFY |
| Companion Android | Periférico GATT | `flutter_ble_peripheral` 3.x | UUID en adv; código en scan response (`serviceData`); sin `includeDeviceName` (límite 31 B) |

**Plan B:** si el stack Windows falla en campo, mantener escaneo manual en búsqueda; tests/CI usan siempre `StreamScannerIngress`.

## Diseño

| Tema | Decisión |
|------|----------|
| Pareo | POS genera código 4 dígitos; companion anuncia UUID + service data con el código (Android); central matchea vía `companionPairingMatches` |
| Payload | UTF-8, trim, máx 512 B (`scan_payload_codec`) |
| Match carro | 1 resultado → `addLine`; 0 → SnackBar; N>1 → solo búsqueda |
| Debounce | 300 ms mismo payload en `BleCentralScannerIngress` |

**SLICE-27 (prep piloto):** índice [`runbooks/ble-piloto-indice.md`](../../runbooks/ble-piloto-indice.md), evidencia y guía UI en Vender; no cierra SC-011-BLE-01 en hardware.