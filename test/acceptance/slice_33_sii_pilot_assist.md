# SLICE-33 — Asistencia piloto SII (`sale_id`)

Facilita evidencia **SC-080-03** sin sustituir el piloto manual en certificación.

## SC-080-ASSIST-UI-01 — `sale_id` visible tras checkout

```gherkin
Dado turno abierto y venta cobrada en la pantalla Vender
Cuando aparece el diálogo Venta registrada
Entonces una línea Venta (sale_id) muestra el identificador local de la venta
```

Verificación: `apps/pos_app/test/sii_checkout_evidence_ui_test.dart`, clave `checkout_sale_id_label`.

## SC-080-03 — Piloto cert (operador)

```gherkin
Dado Gate 0 y variables Fase B en dispositivo
Cuando el operador emite boleta en ambiente cert
Entonces registra folio y sale_id en sii-cert-pilot-evidence.md hasta CERRADO
```

Verificación: `runbooks/sii-cert-pilot-evidence.md` estado **CERRADO** (⬜ hasta ejecución).