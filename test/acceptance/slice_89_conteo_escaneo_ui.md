# SLICE-89 — UI conteo inventario por escaneo

**RF:** RF-088  
**Pantalla:** `InventoryCloseScreen`  
**Tests:** `apps/pos_app/test/inventory_close_scan_ui_e2e_test.dart`

## SC-088-SCAN-UI-01 — Confirm por escaneo

Dado supervisor con turno abierto y producto con barcode, cuando inicia sesión `countScan`, escanea y confirma, entonces snack de éxito y stock queda al cantidad contada (solo SKU escaneados).

## SC-088-SCAN-UI-02 — Regresión manual

Dado pantalla con preview cargado, cuando alterna a escaneo y vuelve a manual, entonces lista preview y submit manual siguen operativos (SC-088-UI histórico).

## SC-088-SCAN-UI-03 — Alta producto

Dado código desconocido en sesión de conteo, cuando confirma crear producto en el diálogo, entonces navega a `ProductCreateScreen` con flujo de alta.

## SC-088-SCAN-UI-04 — Sin líneas

Dado sesión sin bips, cuando confirma conteo, entonces mensaje de validación y sin snack de éxito.