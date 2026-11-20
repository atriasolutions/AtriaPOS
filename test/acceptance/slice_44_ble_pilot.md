# SLICE-44 — Piloto BLE (SC-011-BLE-01)

Formaliza el piloto manual en dispositivo (slices 17–18 y 27 entregaron código y prep). **SLICE-44** no cierra SC-011-BLE-01 hasta evidencia **CERRADO** en hardware.

## SC-011-BLE-01 — Pareo y escaneo en tienda

```gherkin
Dado POS Windows con Bluetooth LE y companion Android instalado
Y un producto de prueba con QR en el catálogo
Y turno abierto en pantalla Vender
Cuando el operador sigue runbooks/ble-scanner-pairing.md
Entonces el POS muestra código de pareo de 4 dígitos
Y el companion se conecta y el estado en POS es Conectado
Y escanear el QR agrega el producto correcto al carro
Y el operador registra fecha, modelos y código en ble-scanner-pilot-evidence.md
```

Verificación manual: [`runbooks/ble-scanner-pilot-evidence.md`](../../runbooks/ble-scanner-pilot-evidence.md) estado **CERRADO**.

Verificación automatizada previa (no sustituye piloto): `scan_payload_codec_test.dart`, `scanner_ble_ui_test.dart`, `scanner_ble_push_test.dart` (SC-011-BLE-02 / UI).

## SC-011-BLE-01-HANDOFF — Slice sin hardware

```gherkin
Dado que el piloto real aún no se ejecutó en dispositivo
Cuando se cierra SLICE-44 documental
Entonces ble-scanner-pilot-evidence.md permanece en estado PREPARADO
Y la sección Pendiente operador lista los 6 pasos mínimos
Y docs/12b mantiene SC-011-BLE-01 como manual pendiente
```

Verificación: `test/acceptance/slice_44_ble_pilot.md`, fila SLICE-44 en `docs/10-plan-entregas.md`.

## Pendiente operador (checklist mínimo)

1. `scripts/ci-local.ps1` verde en la rama de trabajo.
2. `flutter run -d windows` en `apps/pos_app`; companion en Android.
3. Turno → **Vender** → **Conectar escáner** → anotar código.
4. Companion: código → **Anunciar y escanear** → **Conectado** en POS.
5. Escanear QR del producto; confirmar línea en carro.
6. Completar evidencia; estado **CERRADO**; actualizar comentario en `docs/12b-matriz-verificacion-automatizacion.md`.