# SLICE-85 — Sesión de escaneo (contrato API)

## SC-085-01

```gherkin
Dado supervisor con permiso ajustar inventario
Cuando crea sesión receiptScan con guía y lote válidos
Entonces estado draft y referencias normalizadas
```

## SC-085-02

```gherkin
Dado supervisor
Cuando crea sesión countScan
Entonces no exige guía ni lote
```

## SC-085-03 / 04

```gherkin
Dado sesión draft y producto con barcode
Cuando escanea dos veces con intervalo mayor a 400 ms
Entonces quantity es 2
Cuando escanea de nuevo antes de 400 ms
Entonces quantity no aumenta
```

## SC-085-05

```gherkin
Dado código sin producto
Entonces 404 con canCreateProduct en details
```

## SC-085-06

```gherkin
Dado cajero
Cuando crea sesión
Entonces 403
```

## SC-085-07

```gherkin
Dado sesión cancelada
Cuando intenta nuevo bip
Entonces 400
```

Verificación: `packages/core/test/api/scan_session_service_test.dart`, DEC-052.