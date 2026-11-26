# SLICE-136 — Más opciones + piloto armed (Android)

## SC-136-01 (automatizado)

Al abrir la app, no hay `companion_lan_url_field`. Tras expandir **Más opciones**, aparecen el campo y **Usar este enlace**. SC-119-* sigue pasando con el helper de pegado.

## SC-136-DOC-01

Existen `docs/decisiones/DEC-companion-armed-scan.md` (DEC-065) y runbooks actualizados con nombres de botones y flujo armed.

## SC-136-UI-01 (manual)

```gherkin
Dado la app Android en la caja
Cuando escaneo un producto en el visor
Entonces el POS no recibe el código hasta pulsar Escanear
Y solo entonces llega una vez al carrito
```