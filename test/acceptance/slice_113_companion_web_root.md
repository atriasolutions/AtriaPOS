# SLICE-113 — Root PWA válido companion LAN

## Contexto

Corrige el piloto donde el celular veía `No encontrado` al escanear el QR si `COMPANION_WEB_ROOT` apuntaba a una carpeta sin `index.html`.

## Escenarios

### SC-113-01
Dado `COMPANION_WEB_ROOT` con `index.html`  
Cuando se resuelve la carpeta de estáticos  
Entonces se usa esa carpeta.

### SC-113-02
Dado `COMPANION_WEB_ROOT` sin `index.html` y candidato con build válido  
Cuando se resuelve la carpeta  
Entonces se usa el candidato (no la carpeta vacía del define).

### SC-113-03
Dado ningún build válido  
Cuando se resuelve la carpeta  
Entonces `null`.

### SC-113-04
Dado POS con companion HTTPS y sin PWA válida  
Cuando abro el diálogo QR  
Entonces no hay QR ni URL y aparece `companion_pwa_missing` con pasos del script.

## Automatización

- `apps/pos_app/test/companion_lan_config_test.dart` (SC-113-01…03)
- `apps/pos_app/test/companion_pwa_root_test.dart` (SC-113-04)

## Manual

Ver plan slice: `prepare-companion-pwa.ps1`, reinicio POS, QR abre `/companion/`.