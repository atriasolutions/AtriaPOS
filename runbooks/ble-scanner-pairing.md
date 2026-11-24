# Pareo escáner companion ↔ POS (BLE GATT)

Índice piloto: [`ble-piloto-indice.md`](ble-piloto-indice.md). Evidencia: [`ble-scanner-pilot-evidence.md`](ble-scanner-pilot-evidence.md).

## Requisitos

- POS en **Windows 10+** con Bluetooth LE (adaptador o dongle BLE).
- POS compilado con **`flutter_blue_plus_windows`** (SLICE-52); sin eso, **Error BLE** al instante.
- Teléfono **Android** con app `scanner_companion` instalada.
- Mismo local; Bluetooth y ubicación concedidos en Android.

## Pasos

1. POS: iniciar sesión, abrir turno, ir a **Vender**.
2. POS: pulsar **Conectar escáner** (`scanner_connect_button`); anotar código de 4 dígitos.
3. Android: abrir companion, ingresar código, **Anunciar y escanear**.
4. Esperar estado **Conectado** en POS (o cerrar diálogo al conectar).
5. Escanear QR de un producto; verificar match único en carro.
6. Registrar evidencia en [`ble-scanner-pilot-evidence.md`](ble-scanner-pilot-evidence.md) (SC-011-BLE-01).

UUIDs: `packages/core/lib/scanner/scanner_ble_constants.dart`