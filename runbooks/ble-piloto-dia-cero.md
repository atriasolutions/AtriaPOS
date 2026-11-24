# Día cero — piloto BLE (antes de tocar hardware)

SLICE-48 deja el piloto **a un paso** de la sesión en tienda. SC-011-BLE-01 sigue manual hasta evidencia **CERRADO**. Requiere código con **SLICE-52** en `main`; piloto formal = **SLICE-50** (no confundir con smoke SC-052-03).

Índice maestro: [`ble-piloto-indice.md`](ble-piloto-indice.md). Pareo detallado: [`ble-scanner-pairing.md`](ble-scanner-pairing.md).

## 1. Verificación en máquina de desarrollo (≈10 min)

| Paso | Acción | OK |
|------|--------|-----|
| 1 | `.\scripts\ci-local.ps1` verde (core, adapters, pos_app, **scanner_companion**) | ☐ |
| 2 | Compilar POS Windows: `flutter run -d windows` en `apps/pos_app` | ☐ |
| 3 | Instalar companion en Android: `flutter run` en `apps/scanner_companion` | ☐ |

En CI/tests el radio BLE está apagado; esto solo valida builds y tests automatizados (SC-048-01).

## 2. Preparar tienda piloto (≈15 min)

| Ítem | Nota |
|------|------|
| Windows 10+ con Bluetooth **activado** y drivers al día | Evitar modo avión |
| Android: BT + **ubicación** concedidos a companion | Requerido por BLE scan en muchos OEM |
| Producto de prueba con **QR único** en catálogo | Sin ambigüedad de barcode |
| Usuario cajero con **turno abierto** | Pantalla **Vender** |

## 3. Sesión en tienda (30–45 min)

Seguir el orden de [`ble-piloto-indice.md`](ble-piloto-indice.md) §3–5:

1. **Vender** → **Conectar escáner** → anotar código 4 dígitos.
2. Companion: código → **Anunciar y escanear** → **Conectado** en POS.
3. Escanear QR → línea correcta en carro.
4. Completar [`ble-scanner-pilot-evidence.md`](ble-scanner-pilot-evidence.md) → estado **CERRADO**.
5. Actualizar comentario SC-011-BLE-01 en [`docs/12b-matriz-verificacion-automatizacion.md`](../docs/12b-matriz-verificacion-automatizacion.md).

Capturas **fuera del repo** (sin datos sensibles).

## 4. Troubleshooting

| Síntoma | Qué revisar |
|---------|-------------|
| No aparece **Conectar escáner** | Build Windows; ingress BLE central en `pos_composition` (no solo HID/cámara) |
| `advertise_failed_data_too_large` en companion | Rebuild companion SLICE-52+ (service data en scan response) |
| **Error BLE** al instante en POS | `flutter pub get` en `pos_app`; dependencia `flutter_blue_plus_windows`; BT activo en Windows |
| Código no parea | Mismo commit POS + APK; mismo código; distancia &lt; 2 m; permisos BT+ubicación Android |
| POS no pasa a **Conectado** | Distancia &lt; 2 m; cerrar otras apps BLE en el teléfono; ver UUIDs en `scanner_ble_constants.dart` |
| Scan no agrega al carro | Producto existe; QR corresponde a un solo SKU; ver debounce 300 ms en ingress |
| Timeouts al escanear | Anotar en evidencia; probar reconexión (cerrar companion y repetir §3) |

## 5. Cierre SLICE-48 vs SC-011-BLE-01

| Artefacto | Estado tras SLICE-48 |
|-----------|----------------------|
| `ble-scanner-pilot-evidence.md` | Sigue **PREPARADO** hasta §3 |
| Acceptance [`slice_48_ble_pre_pilot.md`](../test/acceptance/slice_48_ble_pre_pilot.md) | SC-048-02 |
| Piloto hardware CERRADO | Operador; opcional SLICE-49 solo docs |