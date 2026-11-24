# Evidencia — tienda piloto (agregada)

Checklist de alto nivel. Detalle técnico en evidencias hijas (no commitear capturas sensibles).

Índice operativo: [`tienda-piloto-indice.md`](tienda-piloto-indice.md).

## Estado del documento

| Estado | Significado |
|--------|-------------|
| PREPARADO | Índice maestro leído; demo fake probada o en curso |
| PARCIAL | Al menos una evidencia hija (BLE o SII) avanzada; falta cierre global |
| CERRADO | Demo fake validada + evidencias hijas requeridas por negocio cerradas |

Estado actual: **PARCIAL** — demo fake validada (SLICE-53); BLE formal pendiente (SLICE-50).

## Pre-vuelo tienda

| Ítem | Hecho |
|------|-------|
| `scripts/ci-local.ps1` verde en la rama de trabajo | ☑ |
| Tienda y usuarios de prueba configurados | ☑ |
| Reporte MVP revisado | ☑ |
| [`tienda-piloto-indice.md`](tienda-piloto-indice.md) leído | ☑ |

## Demo fake (obligatoria para CERRADO)

| Ítem | Hecho |
|------|-------|
| Turno → venta → cierre (o flujo acordado) | ☑ |
| DTE fake/replay sin error bloqueante | ☑ |
| Fecha / operador anotados abajo | ☐ _(completar operador)_ |

| Campo | Valor |
|-------|-------|
| Fecha demo | _(completar)_ |
| Operador | _(completar)_ |
| Notas | Piloto núcleo MVP en tienda exitoso; SLICE-53 cierra documentación demo. Bluetooth escáner pendiente (SLICE-50). |

## Evidencias hijas (según alcance piloto)

| Piloto | Runbook evidencia | Estado hijo |
|--------|-------------------|-------------|
| BLE SC-011-BLE-01 | [`ble-scanner-pilot-evidence.md`](ble-scanner-pilot-evidence.md) | **PREPARADO** — prueba Bluetooth diferida; usar `main` con SLICE-52 antes del piloto formal |
| SII SC-080-03 | [`sii-cert-pilot-evidence.md`](sii-cert-pilot-evidence.md) | **CERRADO** (SLICE-37) |

Declarar **producción fiscal** solo si la fila SII está **CERRADO**. El estado global **CERRADO** de este documento exige además BLE **CERRADO** si el negocio lo exige en piloto.