# Índice — piloto escáner BLE (SC-011-BLE-01)

Ruta tienda piloto (maestro): [`tienda-piloto-indice.md`](tienda-piloto-indice.md).

Guía operativa para validar companion Android ↔ POS Windows en tienda piloto. No incluir capturas con datos sensibles en el repositorio.

**Antes del hardware (SLICE-48):** [`ble-piloto-dia-cero.md`](ble-piloto-dia-cero.md) — CI verde, builds y checklist de sesión.

## Orden recomendado

1. **Requisitos hardware y apps**  
   Windows 10+ con Bluetooth LE; Android con `scanner_companion`; permisos BT y ubicación en el teléfono.

2. **UUIDs y constantes** (referencia)  
   `packages/core/lib/scanner/scanner_ble_constants.dart`

3. **Pareo y escaneo**  
   Seguir [`ble-scanner-pairing.md`](ble-scanner-pairing.md) paso a paso.

4. **Venta de prueba**  
   Turno abierto → **Vender** → escanear QR de un producto con match único → verificar línea en el carro → cobrar si aplica.

5. **Evidencia SC-011-BLE-01**  
   Completar [`ble-scanner-pilot-evidence.md`](ble-scanner-pilot-evidence.md) (código de pareo, dispositivos, capturas fuera del repo).

6. **Desconexión**  
   Cerrar companion o finalizar sesión en POS; anotar cualquier fallo de reconexión en evidencia.

## Recordatorios

- En CI/tests el radio BLE está deshabilitado; el piloto real solo en dispositivos.
- Si no aparece **Conectar escáner**, verificar que la app usa ingress BLE central (build Windows con BLE).