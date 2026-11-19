# Pareo escáner companion ↔ POS

1. POS Windows: abrir **Vender** y activar **Conectar escáner** (cuando BLE esté enlazado).
2. Android: abrir app `scanner_companion`, conceder cámara y Bluetooth.
3. Escanear QR de producto; el texto debe aparecer en POS y agregar al carro si hay match único.
4. Evidencia manual: anotar fecha en `test/acceptance/slice_17_ble.md` (SC-011-BLE-01).

UUID servicio: ver `ScannerBleConstants` en `packages/core`.