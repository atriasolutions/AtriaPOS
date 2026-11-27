# SLICE-149 a 151 — Receptor de factura

**Tests:** `invoice_checkout_test.dart`, `invoice_checkout_api_test.dart`, `invoice_checkout_ui_e2e_test.dart`, `sii_dte_xml_builder_test.dart`, `drift_sale_test.dart`

## SC-149

La factura exige RUT, razón social, giro, correo, dirección, ciudad, comuna y teléfono. El XML incluye giro, dirección, comuna y ciudad.

## SC-150-01

Al confirmar, el POS guarda el receptor por RUT de la tienda.

## SC-151

El checkout muestra los ocho campos. El medio de pago sigue apagado hasta que estén completos. Al salir del RUT, si ya existe un cliente, se precargan los datos.
