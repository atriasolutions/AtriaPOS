# SLICE-88 — Conteo inventario por escaneo (core)

**RF:** RF-088 (amend), RF-094  
**Contrato:** `POST .../scan-sessions/{id}/confirm-count` (doc 07)  
**Tests:** `packages/core/test/api/scan_session_count_confirm_test.dart`

## SC-088-SCAN-01 — Confirm parcial

Dado turno abierto y sesión `countScan` con dos productos escaneados (cantidades acumuladas por bip), cuando confirma conteo, entonces responde 200 con `closeId`, líneas con variance y solo esos SKU en el cierre persistido; productos no escaneados no se incluyen ni cambian por el cierre.

## SC-088-SCAN-02 — Sin líneas

Dado sesión `countScan` sin bips, cuando confirma, entonces 400.

## SC-088-SCAN-03 — Tipo incorrecto

Dado sesión `receiptScan`, cuando llama `confirm-count`, entonces 400.

## SC-088-SCAN-04 — Sin turno

Dado sesión con bips y sin turno abierto, cuando confirma, entonces 404.

## SC-088-SCAN-05 — Idempotencia

Dado confirm con `idempotencyKey`, cuando repite la misma clave, entonces 200 con mismo `closeId` y un solo cierre persistido.

## SC-088-SCAN-06 — Doble confirm

Dado sesión ya confirmada, cuando confirma sin clave, entonces 409.

## SC-088-SCAN-07 — Permisos

Dado cajero, cuando confirma conteo, entonces 403.

## SC-088-SCAN-08 — Regresión ingreso

Dado sesión `countScan`, cuando usa `confirm` de ingreso, entonces 400 (SC-086-03).