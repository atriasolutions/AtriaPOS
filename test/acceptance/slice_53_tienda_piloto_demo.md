# SLICE-53 — Piloto tienda demo fake (cierre parcial)

Registra éxito del piloto núcleo sin cerrar SC-011-BLE-01.

## SC-053-01 — Evidencia agregada PARCIAL

```gherkin
Dado piloto tienda núcleo exitoso según operador
Cuando se lee runbooks/tienda-piloto-evidencia.md
Entonces el estado es PARCIAL
Y la sección demo fake está marcada como validada
Y la fila BLE sigue PREPARADO
```

Verificación: [`runbooks/tienda-piloto-evidencia.md`](../../runbooks/tienda-piloto-evidencia.md).

## SC-053-02 — SLICE-50 no cerrado

```gherkin
Dado SLICE-53 cerrado en docs
Cuando se consulta acta §2 y docs/12b fila SC-011-BLE-01
Entonces SLICE-50 figura ABIERTO
Y SC-011-BLE-01 permanece manual pendiente
```

Verificación: [`docs/19-revision-progreso-20251120.md`](../../docs/19-revision-progreso-20251120.md) § revisión 2026-11-24; [`docs/12b-matriz-verificacion-automatizacion.md`](../../docs/12b-matriz-verificacion-automatizacion.md).

## SC-053-03 — SLICE-52 integrado en rama de entrega

```gherkin
Dado la rama feat/slice-53-tienda-piloto-cierre
Cuando se inspecciona el historial
Entonces incluye el commit de SLICE-52 (central BLE Windows)
Y flutter_blue_plus_windows está en apps/pos_app/pubspec.yaml
```

Verificación: `git log`; [`test/acceptance/slice_52_ble_windows_central.md`](slice_52_ble_windows_central.md).