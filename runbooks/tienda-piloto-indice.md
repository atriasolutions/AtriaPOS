# Índice — tienda piloto (ruta operativa unificada)

Punto de entrada para validar el MVP en tienda: demo con DTE fake, pilotos opcionales BLE/SII e integración a `main` si corresponde. Evidencia agregada: [`tienda-piloto-evidencia.md`](tienda-piloto-evidencia.md).

## 1. Pre-requisitos

- Flutter **stable** y suites locales verdes: [`scripts/ci-local.ps1`](../scripts/ci-local.ps1)
- Estado del producto: [`docs/reporte-avances-mvp.md`](../docs/reporte-avances-mvp.md)
- Sin commitear secretos, certificados ni capturas con datos sensibles

## 2. Integración código (opcional)

No bloquea la demo en tienda.

- Checklist y PR: [`merge-mvp-hito.md`](merge-mvp-hito.md), [`pr-body-mvp.md`](pr-body-mvp.md)

## 3. Demo tienda — DTE fake/replay

Modo por defecto de la app (`FakeDteGateway` / sin `SII_GATEWAY=live`).

1. Alta de tienda (onboarding) y usuario dueño si la DB está vacía
2. Login cajero → abrir turno
3. Venta: buscar producto, cobrar, verificar boleta fake y stock
4. Supervisor: cierre de caja, reporte del día (opcional)

Referencia automatizada: `apps/pos_app/test/sale_flow_e2e_test.dart` (SC-060-01).

## 4. Piloto escáner BLE (opcional)

Índice: [`ble-piloto-indice.md`](ble-piloto-indice.md) — evidencia [`ble-scanner-pilot-evidence.md`](ble-scanner-pilot-evidence.md).

Guía en app: pantalla **Vender** (`scanner_pilot_guide`).

## 5. Piloto certificación SII (habilitación fiscal)

Requiere Gate 0 y certificado en dispositivo (nunca en git).

Índice: [`sii-piloto-indice.md`](sii-piloto-indice.md) — evidencia [`sii-cert-pilot-evidence.md`](sii-cert-pilot-evidence.md).

Guía en app: Operación → Certificado SII (`certificate_pilot_guide`).

**Producción fiscal** solo con evidencia SII en estado **CERRADO**.

## 6. Cierre tienda piloto

Completar [`tienda-piloto-evidencia.md`](tienda-piloto-evidencia.md) y las evidencias hijas que el negocio exija (BLE / SII).