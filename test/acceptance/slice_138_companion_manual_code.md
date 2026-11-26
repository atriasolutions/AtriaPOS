# SLICE-138 — Código manual en Android (visor)

Paridad con PWA: ingreso por teclado si la etiqueta no lee bien.

## SC-138-01 (automatizado)

`companion_lan_manual_code_field` oculto hasta expandir **Escribir código**.

## SC-138-02 (automatizado)

Texto + **Enviar código** → mismo WebSocket que cámara armed.

## SC-138-UI-01 (manual)

```gherkin
Dado sesión vender activa
Cuando expande Escribir código y escribe un EAN
Entonces el producto llega al carrito sin usar la cámara
```