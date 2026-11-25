# SLICE-92 — Nota de crédito electrónica (core)

**RF:** RF-096, DEC-055  
**API:** `POST .../credit-notes`  
**Tests:** `issue_credit_note_test.dart`, `credit_note_api_test.dart`, `credit_note_xml_test.dart`

## SC-092-01 — NC total

Venta emitida → NC total → stock restaurado, venta `ANULADA`, folio NC.

## SC-092-02 — NC parcial

Dos unidades vendidas; NC de 1; venta sigue confirmada; segunda NC completa anula.

## SC-092-03 — Regresión void

Venta no emitida sigue anulándose con `void` sin NC.

## SC-092-04 — Void bloqueado

`EMITIDA` + `void` → mensaje que indica `credit-notes`.

## SC-092-05 — Cola

NC con emisión pendiente en cola; `retry` emite y persiste folio.

## SC-092-06 — Permisos

Cajero no emite NC.

## SC-092-07 — Turno

Solo ventas del turno abierto.

## SC-092-08 — Devolución pura

NC parcial sin `ProductExchange`.

## SC-092-09 — Cambio fiscal

Tras NC emitida parcial, `registerProductExchange` con `creditNoteId` en venta emitida.