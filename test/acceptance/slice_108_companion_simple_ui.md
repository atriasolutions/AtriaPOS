# SLICE-108 — PWA companion pantalla simple

## Escenarios

### SC-108-01 etiquetas modo
Dado un `CompanionMode`  
Entonces la etiqueta en pantalla es Vender / Ingreso mercadería / Conteo inventario

### SC-108-02 reglas de visibilidad
Dado el estado de sesión  
Entonces sin UUID de tienda, sin cámara, escaneo solo si conectado, Reintentar solo si falló la conexión

### SC-108-03 auto-pair
Dado URL `/companion/?storeId&mode&pairingCode`  
Cuando se abre la PWA  
Entonces empareja sin botón manual y sin mostrar tienda

### SC-108-04 ingreso manual
Dado sesión conectada  
Entonces campo grande y botón Enviar escaneo habilitado

### SC-108-05 regresión parse
Dado query del redirect 107  
Entonces `CompanionLaunchParams` sigue válido (SC-100-01)

### SC-108-06 sin QR
Dado URL sin query  
Entonces mensaje para escanear QR del POS y sin formulario de escaneo

## Automatización

`apps/companion_web/test/` — SC-108-01…06

## Fuera de alcance (en 108)

Cámara (véase SLICE-110), HTTPS (véase SLICE-109).