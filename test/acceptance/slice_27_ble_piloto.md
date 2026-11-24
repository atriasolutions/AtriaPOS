# SLICE-27 — Prep piloto escáner BLE

Preparación operativa de SC-011-BLE-01 (no sustituye la evidencia manual en dispositivos).

## SC-011-PREP-01 — Índice y traza operativa

```gherkin
Dado un operador que ejecutará el piloto BLE en tienda
Cuando consulta los runbooks
Entonces encuentra índice en runbooks/ble-piloto-indice.md enlazado a ble-scanner-pairing.md y ble-scanner-pilot-evidence.md (pre-vuelo y estados PREPARADO/CERRADO)
```

Verificación: `runbooks/ble-piloto-indice.md`, `runbooks/ble-scanner-pilot-evidence.md`, enlaces en `ble-scanner-pairing.md`.

## SC-011-PREP-UI-01 — Guía piloto (runbook-only, SLICE-80)

La guía ya **no** se muestra en Vender; referencia operativa en `runbooks/ble-piloto-indice.md`.

Verificación: `scanner_ble_ui_test.dart` (SC-080-01).

## SC-011-BLE-01 — Piloto real (manual)

Trazabilidad documental en **SLICE-44**: `test/acceptance/slice_44_ble_pilot.md`. Evidencia en dispositivo: `runbooks/ble-scanner-pilot-evidence.md` estado **CERRADO** (hasta entonces **PREPARADO**).