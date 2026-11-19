# SLICE-21 — Estado certificado SII (RF-003 / API-010)

## SC-003-01 — Consulta estado sin error

```gherkin
Dado supervisor autenticado y certificado vigente, vencido o ausente en dispositivo
Cuando consulta estado fiscal
Entonces recibe VALIDO, VENCIDO o NO_CONFIGURADO sin excepción de dominio
```

Verificación: `packages/core/test/application/get_certificate_status_test.dart`, `packages/core/test/api/fiscal_service_test.dart`

## SC-003-UI-01 — Pantalla certificado

```gherkin
Dado supervisor en Vender con certificado configurado en tests
Cuando abre Operación → Certificado SII
Entonces ve badge de estado y titular
```

Verificación: `apps/pos_app/test/certificate_status_ui_e2e_test.dart`

## SC-003-UI-02 — Cajero sin menú

```gherkin
Dado sesión CAJERO en Vender
Cuando revisa menú Operación
Entonces no aparece "Certificado SII"
```

Verificación: mismo archivo.