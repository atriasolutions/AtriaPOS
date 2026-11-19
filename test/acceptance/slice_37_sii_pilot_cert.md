# SLICE-37 — Piloto certificación SII (SC-080-03)

## SC-080-03 — Emisión live en certificación

```gherkin
Dado Gate 0 completado y certificado vigente en dispositivo
Y la app arranca con SII_GATEWAY=live y SII_AMBIENTE=cert
Cuando el operador realiza una venta de prueba y cobra
Entonces el diálogo muestra dteStatus EMITIDA y folio
Y el folio es visible en el portal SII certificación
Y el operador registra sale_id (Copiar sale_id) en evidencia
Y vuelve a SII_GATEWAY=fake para demos
```

Verificación manual: [`runbooks/sii-cert-pilot-evidence.md`](../../runbooks/sii-cert-pilot-evidence.md) estado **CERRADO**.

## SC-080-03-ROLLBACK — Vuelta a demo

```gherkin
Dado piloto certificación cerrado
Cuando se ejecuta flutter run sin live (default fake)
Entonces las ventas demo no requieren certificado en dispositivo
```