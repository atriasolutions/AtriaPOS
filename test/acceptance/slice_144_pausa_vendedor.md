# SLICE-144 — Cobro sin código vendedor

**Tests:** `checkout_template_policy_test.dart`, `confirm_checkout_test.dart`, `seller_code_checkout_test.dart`, `seller_code_checkout_ui_e2e_test.dart`

## SC-144-01

Atria POS no exige `sellerCode`. La planilla sigue en la plantilla.

## SC-144-02

Checkout con `sellerCode` vacío confirma y no persiste código.

## SC-144-UI-01

Sin colaboradores, el botón de cobro está habilitado y no se muestra «Vendedor».
