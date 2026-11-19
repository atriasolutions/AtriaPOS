# SLICE-17 — Escáner BLE companion

## SC-011-BLE-01 — Lectura remota (manual)

```gherkin
Given companion Android y POS Windows pareados
When escaneo QR de producto
Then POS busca y agrega línea si match único
```

Evidencia: `runbooks/ble-scanner-pairing.md`.