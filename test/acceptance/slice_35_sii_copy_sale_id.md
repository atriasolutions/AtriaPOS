# SLICE-35 — Copiar `sale_id` (piloto SII)

## SC-080-ASSIST-UI-02 — Portapapeles

```gherkin
Dado una venta cobrada con diálogo Venta registrada visible
Cuando el operador pulsa Copiar sale_id
Entonces el portapapeles contiene el sale_id y se confirma en pantalla
```

Verificación: `apps/pos_app/test/sii_checkout_evidence_ui_test.dart` (SC-080-ASSIST-UI-02).

## SC-080-03 — Piloto cert (operador)

```gherkin
Dado ambiente cert y certificado en dispositivo
Cuando se emite boleta de prueba
Entonces se pega sale_id en sii-cert-pilot-evidence.md hasta CERRADO
```

Verificación: `runbooks/sii-cert-pilot-evidence.md`.