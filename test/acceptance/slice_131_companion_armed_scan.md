# SLICE-131 — Un envío por toque (app Android)

La cámara guarda el código visto; el WebSocket solo recibe al pulsar **Escanear**.

## SC-131-01 (automatizado)

Dado el visor de productos
Cuando el mismo código se detecta dos veces sin tocar Escanear
Entonces no hay mensaje `scan` hacia el POS

## SC-131-02 (automatizado)

Dado un código en el buffer
Cuando el usuario pulsa Escanear y vuelve a pulsar sin nueva detección
Entonces hay un solo envío

## SC-131-03 (automatizado)

Detectar A, Escanear, detectar B, Escanear → dos envíos.

## SC-131-04 (automatizado)

Escanear sin código previo → cero envíos; el estado del visor sigue visible.

## SC-131-UI-01 (manual)

```gherkin
Dado el celular conectado y un código de barras en el visor unos segundos
Cuando el usuario no pulsa Escanear
Entonces el POS no agrega líneas
Cuando pulsa Escanear una vez
Entonces el POS recibe ese código una vez
Y un segundo toque inmediato no duplica
```
