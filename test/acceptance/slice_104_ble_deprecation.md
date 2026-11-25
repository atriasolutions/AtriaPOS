# SLICE-104 — Companion BLE fuera del default

## Criterio

En Windows, `PosComposition.lanCompanionDefault = true` usa `LanScannerIngress` y QR WiFi en lugar de `BleCentralScannerIngress` por defecto.

BLE sigue disponible con `lanCompanionDefault = false` o override de ingress en tests (`scanner_ble_*`).

## Automatización
Regresión: `scanner_ble_push_test.dart` con ingress explícito BLE/stream.