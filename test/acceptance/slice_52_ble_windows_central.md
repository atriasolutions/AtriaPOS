# SLICE-52 — Central BLE Windows (intermedio)

Desbloquea escaneo/conexión BLE en `pos_app` Windows. **No** cierra SC-011-BLE-01 (SLICE-50).

## SC-052-01 — Plugin Windows + pareo service data

```gherkin
Dado core con companionPairingMatches y pareo por service data
Cuando se ejecuta dart test en packages/core/test/scanner/
Entonces SC-011-BLE-03 pasa junto a SC-011-BLE-02
```

Verificación: `companion_pairing_match_test.dart`, `scan_payload_codec_test.dart`.

## SC-052-02 — POS importa stack Windows

```gherkin
Dado pos_app con flutter_blue_plus_windows y BleCentralScannerIngress
Cuando flutter test incluye scanner_ble_* en CI
Entonces las pruebas UI BLE pasan con enableRadio false
```

Verificación: `apps/pos_app/pubspec.yaml`; `scanner_ble_ui_test.dart`; `scanner_ble_push_test.dart`.

## SC-052-03 — Smoke manual hardware (DoD slice)

```gherkin
Dado el mismo commit en POS Windows y APK companion
Cuando el operador sigue ble-scanner-pairing.md
Entonces Conectar escáner no muestra Error BLE inmediato
Y aparece Buscando… o Conectado tras anunciar en el teléfono
Y un QR de producto agrega línea al carro si está Conectado
```

| Paso | OK | Notas |
|------|-----|-------|
| POS `flutter run -d windows` (mismo commit) | ☐ | |
| APK companion rebuild + install | ☐ | |
| Sin Error BLE al instante | ☐ | |
| Estado Conectado | ☐ | |
| QR → carro | ☐ | |

Registro operador (fecha, commit, PC): _pendiente cierre sesión_.

SC-011-BLE-01 formal sigue en `runbooks/ble-scanner-pilot-evidence.md` (SLICE-50).