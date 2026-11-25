# SLICE-93 — Factura electrónica en checkout

**RF:** RF-097, DEC-055  
**API:** `POST .../checkout` con `documentType` FACTURA  
**Tests:** `invoice_checkout_test.dart`, `invoice_checkout_api_test.dart`, `invoice_checkout_ui_e2e_test.dart`, `sii_dte_xml_builder_test.dart`, `credit_note_xml_test.dart`

## SC-093-01 — Checkout factura

RUT y razón social válidos → venta tipo 33 EMITIDA, receptor persistido.

## SC-093-02 — RUT inválido

→ `VALIDACION`.

## SC-093-03 — Razón social vacía

→ `VALIDACION`.

## SC-093-04 — Boleta por defecto

Sin `documentType` → tipo 39.

## SC-093-05 — Plantilla

`barrioMinTest` + factura → `VALIDACION`.

## SC-093-06 — Cola DTE

Factura `PENDIENTE_DTE` en cola con `documentType` 33; retry emite.

## SC-093-07 — NC sobre factura

`TpoDocRef` 33 en XML NC.

## SC-093-UI-01…03

Selector boleta/factura, checkout factura, snackbar RUT inválido.