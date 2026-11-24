# SLICE-56 — Identidad técnica Atria POS (Fase B)

## SC-056-01 — kAppName y barrel

```gherkin
Dado SLICE-56 integrado
Cuando se ejecuta dart test packages/core/test/smoke_test.dart
Entonces kAppName es "Atria POS"
Y el barrel público es package:core/atria_pos_core.dart
```

Verificación: [`packages/core/test/smoke_test.dart`](../../packages/core/test/smoke_test.dart).

## SC-056-02 — BLE Atria-POS

```gherkin
Dado core actualizado
Cuando se lee ScannerBleConstants.deviceNamePrefix
Entonces el valor es Atria-POS
Y companionPairingMatches acepta advName Atria-POS-{código}
```

Verificación: [`packages/core/lib/scanner/scanner_ble_constants.dart`](../../packages/core/lib/scanner/scanner_ble_constants.dart); `companion_pairing_match_test.dart`.

## SC-056-03 — Política SQLite

```gherkin
Dado resolveSqlitePath
Cuando existe pos_barrio.sqlite en el directorio
Entonces se usa esa ruta
Cuando no existe legado
Entonces se usa atria_pos.sqlite
```

Verificación: [`packages/core/test/app_database_paths_test.dart`](../../packages/core/test/app_database_paths_test.dart); DEC-044.