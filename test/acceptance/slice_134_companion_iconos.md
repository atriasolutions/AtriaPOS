# SLICE-134 — Íconos Material (app Android)

## SC-134-01 / SC-134-02 (automatizado)

Empareje: `qr_code_scanner` y `link`. Trabajo: `logout` y `document_scanner` junto a las keys existentes.

## SC-134-UI-01 (manual)

```gherkin
Dado la app en pantalla principal
Entonces el botón principal muestra ícono de escaneo
Cuando está conectado a la caja
Entonces Escanear y Salir de la caja tienen ícono legible
```