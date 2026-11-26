# SLICE-137 — PWA companion armed (paridad Android)

## SC-137-01 / SC-137-02 (unit)

`CompanionArmedScan` en `companion_web`: buffer + trigger.

## SC-137-03 (widget)

Sin lectura de cámara, `companion_camera_send_button` deshabilitado.

## SC-110-04 (widget, actualizado)

Simular detección → chip Listo → **Escanear** → `sendScan` igual que manual.

## SC-137-UI-01 (manual HTTPS)

```gherkin
Dado PWA emparejada con cámara
Cuando el visor lee un código
Entonces no llega al POS hasta pulsar Escanear
```