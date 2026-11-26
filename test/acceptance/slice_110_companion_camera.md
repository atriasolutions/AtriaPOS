# SLICE-110 — PWA companion cámara o manual

## Escenarios

### SC-110-01 visor cámara conectado
Dado sesión emparejada (`connected`)  
Entonces se ofrece bloque de cámara sobre el formulario manual

### SC-110-02 sin cámara antes de sesión
Dado fase `awaitingQr`, `pairing` o `connectionFailed`  
Entonces no se muestra bloque de cámara

### SC-110-03 deduplicación lectura
Dado el mismo código en menos de 400 ms  
Entonces no se reenvía al POS

### SC-110-04 escaneo cámara → WS
Dado cámara activa y código detectado  
Cuando el operador pulsa **Escanear** (DEC-065, SLICE-137)  
Entonces `sendScan` envía el mismo payload que ingreso manual

### SC-110-05 manual siempre disponible
Dado sesión conectada con bloque cámara  
Entonces campo manual y botón Enviar siguen visibles

### SC-110-06 degradación cámara
Dado navegador sin cámara (`unsupported` u otro error)  
Entonces no hay visor vacío 220px; mensaje breve y manual

### SC-110-07 regresión parse QR
Dado query de lanzamiento  
Entonces `CompanionLaunchParams` sigue válido (SC-100-01)

## Automatización

`apps/companion_web/test/` — SC-110-01…07

## Piloto manual (HTTPS + CA)

Tras instalar CA (`runbooks/companion-lan-install-ca.md`):

1. Emparejar por QR, confirmar que el visor de cámara aparece.
2. Leer código con la cámara; pulsar **Escanear**; verificar llegada al POS.
3. Si cámara bloqueada: solo mensaje breve + ingreso manual (operación válida).

Registrar PASA/FALLA en `runbooks/companion-lan-install-ca.md` § Cámara.

## Fuera de alcance

Estado celular en POS (111), e2e triple flujo (112).