# DEC-067 — Perfil operativo por tienda

**Estado:** ✅ Decidido (2026-11-27)  
**Prioridad:** P0  
**Slices:** 161–165

## Decisión

1. Cada tienda persiste `operationalOverrides` (JSON versionado) además de `posTemplateId`.
2. Comportamiento efectivo = features de plantilla ([`PosTemplateRegistry`](../packages/core/lib/domain/pos_template_definition.dart)) **más** overrides booleanos por flag v1.
3. Solo **DUENO** puede `PATCH` overrides (permiso `gestionarConfigTienda`).
4. `GET .../store-operational-config` devuelve overrides, `schemaVersion` y `effectiveFeatures`.
5. `GET .../pos-template` sigue existiendo y refleja el **perfil efectivo** (compatibilidad UI).

## Flags v1

| Override | Feature afectada |
|----------|------------------|
| `sellerCodeRequired` | `sellerCodeCheckout` |
| `invoiceCheckoutEnabled` | `invoiceCheckout` |
| `transbankEnabled` | `transbankIntegration` |
| `receiptRequiresGuiaLote` | `stockReceiptGuiaLote` |
| `trackExpiryOnReceipt` | `trackExpiryOnReceipt` |
| `inventoryCloseEnabled` | `inventoryClose` |
| `dteEnabled` | `dteQueue`, `fiscalCertificate` |

`null` en override = no cambia respecto a la plantilla.