# SLICE-135 — Pantalla de trabajo (layout)

Visor a pantalla casi completa, estado legible y botón **Escanear** ancho. Deshabilitado hasta haber leído un código.

## SC-135-01 (automatizado)

Sin detección, el botón Escanear está deshabilitado.

## SC-135-02 (automatizado)

Tras detectar un código, el botón se habilita y muestra el chip Listo.

## SC-135-UI-01 (manual)

```gherkin
Dado el celular conectado en modo Vender
Cuando abre el visor
Entonces la cámara ocupa la mayor parte de la pantalla
Y Escanear está abajo, ancho, y deshabilitado hasta apuntar a un código
```