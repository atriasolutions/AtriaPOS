# SLICE-125 — QR del POS: un solo cierre de pantalla

## SC-125-01 — Automatizado

Doble entrega del mismo enlace `/c/{codigo}` no deja la app sin ruta (sigue visible **Conectar al POS**).

## SC-125-UI-01 — Manual

```gherkin
Dado el POS con QR vigente y la app en Conectar
Cuando el usuario toca Leer QR del POS y escanea una vez
Entonces vuelve a Conectar y muestra Conectado, sin pantalla negra indefinida
Y en el POS figura celular conectado
```