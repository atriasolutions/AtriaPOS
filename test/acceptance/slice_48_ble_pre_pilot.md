# SLICE-48 — Pre-piloto BLE (prep soft)

Avanza SC-011-BLE-01 sin sustituir el piloto en hardware (handoff SLICE-44). CI incluye `scanner_companion`.

## SC-048-01 — Suites BLE automatizadas

```gherkin
Dado scripts/ci-local.ps1 con paso scanner_companion
Cuando se ejecuta ci-local en la rama del slice
Entonces dart test en core y adapters pasan
Y flutter test en pos_app pasa incluyendo scan_payload_codec y scanner_ble_* 
Y flutter test en scanner_companion pasa widget_test de pareo
```

Verificación: `scripts/ci-local.ps1`; `packages/core/test/scan_payload_codec_test.dart`; `apps/pos_app/test/scanner_ble_ui_test.dart`; `apps/pos_app/test/scanner_ble_push_test.dart`; `apps/scanner_companion/test/widget_test.dart`.

## SC-048-02 — Evidencia manual sigue PREPARADO

```gherkin
Dado que no hubo sesión BLE en dispositivos reales en este slice
Cuando se cierra SLICE-48
Entonces ble-scanner-pilot-evidence.md permanece en estado PREPARADO
Y SC-011-BLE-01 en docs/12b sigue manual pendiente
```

Verificación: `runbooks/ble-scanner-pilot-evidence.md`; fila SC-011-BLE-01 en `docs/12b-matriz-verificacion-automatizacion.md`.

## SC-048-03 — Runbook día del piloto

```gherkin
Dado un operador con hardware disponible
Cuando abre ble-piloto-dia-cero.md desde ble-piloto-indice.md
Entonces encuentra prerequisitos, orden de sesión y troubleshooting
Y enlaces a ble-scanner-pairing.md y ble-scanner-pilot-evidence.md
```

Verificación: `runbooks/ble-piloto-dia-cero.md`, `runbooks/ble-piloto-indice.md`.