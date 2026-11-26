# SLICE-132 — Conectar aterriza en pantalla de trabajo

Tras un empareje correcto, la app Android muestra el visor de productos. El formulario de enlace queda detrás y no se usa hasta **Cerrar conexión**.

## SC-132-01 (automatizado)

Dado un enlace válido
Cuando el usuario conecta
Entonces aparece el botón `companion_lan_send_scan_button`
Y no se ve el campo de enlace en esa pantalla

## SC-132-02 (automatizado)

Dado el visor de trabajo
Cuando pulsa Cerrar conexión
Entonces vuelve el formulario de empareje
Y no queda el texto Conectado

## SC-132-UI-01 (manual)

```gherkin
Dado el QR de la caja y la app en Conectar
Cuando el usuario lee el código
Entonces entra al visor de productos (modo Vender / Ingreso / Conteo)
Y no ve Leer QR ni Conectar
Cuando pulsa Cerrar conexión
Entonces vuelve a Conectar a la caja
```
