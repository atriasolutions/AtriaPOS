# DEC — Escáner BLE (SLICE-17)

| Tema | Decisión |
|------|----------|
| Apps | `apps/scanner_companion` (Android) + receptor en `pos_app` |
| Protocolo | UTF-8 en characteristic `ScannerBleConstants.scanCharacteristicUuid` |
| MVP | Companion escanea; envío BLE documentado en runbook (GATT write iteración 2) |
| Tests | `StreamScannerIngress` en e2e y unit |