# SLICE-133 — Copy de caja (app Android)

Textos orientados al operador de mostrador; sin “POS” ni “QR” en el camino feliz.

## SC-133-01 (automatizado)

Pantalla principal: **Conectar a la caja**, intro, **Leer código de la caja**; sin campo de enlace visible; sin texto “POS”.

## SC-133-UI-01 (manual)

```gherkin
Dado la app abierta
Entonces el botón principal dice Leer código de la caja
Y no hay campo de enlace hasta pulsar Pegar enlace
Cuando sale del visor con Salir de la caja
Entonces vuelve a Conectar a la caja
```