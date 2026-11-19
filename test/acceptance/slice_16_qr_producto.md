# SLICE-16 — QR producto

## SC-010-QR-01 — Payload al crear

```gherkin
Cuando creo producto
Entonces qrPayload contiene store y product id
```

## SC-011-QR-01 — Búsqueda por QR

```gherkin
Cuando busco con payload QR completo
Entonces encuentro el producto
```