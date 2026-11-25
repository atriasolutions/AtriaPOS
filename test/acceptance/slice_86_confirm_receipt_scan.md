# SLICE-86 — Confirmar ingreso desde sesión escaneada

## SC-086-01

```gherkin
Dado sesión receiptScan con líneas escaneadas
Cuando confirma ingreso
Entonces un RECEPCION por producto y sesión confirmed
```

## SC-086-02

```gherkin
Dado sesión sin líneas
Entonces confirmación 400
```

## SC-086-03

```gherkin
Dado sesión countScan
Entonces confirmación 400
```

## SC-086-04 / 05

```gherkin
Dado sesión ya confirmada
Entonces segundo confirm 409 o idempotency 200
```

## SC-086-06

```gherkin
Dado cajero
Entonces 403
```

## SC-086-07

```gherkin
Dado confirmación exitosa
Entonces movimiento con guía y lote de sesión
```

Verificación: `scan_session_confirm_test.dart`.