# 05 — Requisitos no funcionales

## Rendimiento

| ID | Requisito |
|----|-----------|
| RNF-001 | Búsqueda producto local p95 &lt; 500 ms con hasta 5.000 SKU |
| RNF-002 | Confirmar venta local (sin SII) p95 &lt; 1 s |
| RNF-003 | App usable en Android 10+ y Windows desktop (Flutter) |

## Disponibilidad y offline

| ID | Requisito |
|----|-----------|
| RNF-010 | Operar ventas sin red ≥ 8 h con cola DTE local |
| RNF-011 | Al recuperar red, reintentar cola con backoff y tope de intentos configurable |
| RNF-012 | Datos locales cifrados en reposo (clave derivada del dispositivo o PIN tienda) |

## Seguridad

| ID | Requisito |
|----|-----------|
| RNF-020 | Autenticación local: PIN o biometría por usuario |
| RNF-021 | Certificado digital nunca en repositorio ni logs |
| RNF-022 | Sesión cajero expira tras inactividad (configurable, default 15 min) |
| RNF-023 | PII mínima; cumplir práctica razonable Ley 19.628 / futura protección datos |

**[OBSERVADO]** Integración SII y manejo de certificados requiere confirmación explícita del cliente antes de producción.

## Hora y periféricos (SLICE-15–17)

| ID | Requisito |
|----|-----------|
| RNF-040 | Sincronización hora con ntp.shoa.cl (fallback IP); UI muestra reloj |
| RNF-041 | Escáner externo: BLE legacy → **companion web WiFi** (Bloque B, DEC-056); cámara en PWA Android |

## Calidad y TDD

| ID | Requisito |
|----|-----------|
| RNF-030 | Cobertura ≥ 80 % en `packages/core` (dominio + casos de uso) |
| RNF-031 | Todo RF [M] tiene ≥ 1 escenario automatizado en suite de comportamiento |
| RNF-032 | API pública versionada; cambios breaking solo con migración documentada |

## Accesibilidad y UX

| ID | Requisito |
|----|-----------|
| RNF-040 | Contraste y tamaño mínimo legible en sol directo (patio de minimarket) |
| RNF-041 | Flujo venta: máximo 3 taps desde producto escaneado hasta pantalla de pago |
| RNF-042 | Mensajes de error en español chileno, sin códigos crudos al cajero |
| RNF-043 | Operación inventario: controles interactivos ≥ 56 px; estados con texto e icono, no solo color (SLICE-156) |

## Observabilidad

| ID | Requisito |
|----|-----------|
| RNF-050 | Logs estructurados sin datos tributarios sensibles en claro |
| RNF-051 | Métricas: ventas/hora, tasa fallo DTE, tiempo cola offline |