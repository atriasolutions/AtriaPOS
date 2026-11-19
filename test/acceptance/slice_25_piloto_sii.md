# SLICE-25 — Prep piloto certificación SII

Preparación operativa de SC-080-03 (no sustituye la evidencia manual en certificación).

## SC-080-PREP-01 — Índice y traza operativa

```gherkin
Dado un operador que ejecutará el piloto en certificación
Cuando consulta los runbooks
Entonces encuentra índice en runbooks/sii-piloto-indice.md enlazado a Gate 0, sii-cert (Fase B) y sii-cert-pilot-evidence (pre-vuelo y estados PREPARADO/CERRADO)
```

Verificación: `runbooks/sii-piloto-indice.md`, `runbooks/sii-cert-pilot-evidence.md`, enlace en `runbooks/sii-cert.md` Fase B.

## SC-080-PREP-UI-01 — Guía piloto en app

```gherkin
Dado un supervisor autenticado
Cuando abre Operación → Certificado SII
Entonces ve la guía de piloto con Key certificate_pilot_guide y referencias a los runbooks sin cargar .pfx desde la UI
```

Verificación: `apps/pos_app/test/certificate_status_ui_e2e_test.dart` (SC-080-PREP-UI-01).

## SC-080-03 — Piloto real (manual, fuera de slice)

Permanece pendiente hasta completar evidencia en dispositivo: `runbooks/sii-cert-pilot-evidence.md` estado **CERRADO**.