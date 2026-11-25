# SLICE-87 — UI ingreso por escaneo

## SC-087-UI-01

```gherkin
Dado producto con barcode y supervisor
Cuando modo escaneo, sesión, bip y confirmar
Entonces snackbar éxito y stock incrementado
```

## SC-087-UI-02

```gherkin
Dado modo manual
Entonces flujo ingreso clásico SC-085-UI-01 sigue vigente
```

## SC-087-UI-03

```gherkin
Dado código desconocido en sesión escaneo
Cuando crear producto
Entonces ProductCreateScreen con barcode precargado
```

## SC-087-UI-04

```gherkin
Dado sesión sin líneas
Cuando confirmar
Entonces error sin snack de éxito
```

Verificación: `stock_receipt_scan_ui_e2e_test.dart`.