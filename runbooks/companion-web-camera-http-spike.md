# Spike SLICE-95b — Cámara companion en HTTP (Android)

Sin secretos en repo.

## Objetivo

Verificar si Chrome Android permite `getUserMedia` / escáner con PWA servida por `http://{LAN-IP}:8765`.

## Procedimiento

1. POS en LAN con servidor activo (post SLICE-97).
2. Abrir URL del companion en Chrome Android (no localhost).
3. Intentar iniciar cámara / escanear código de prueba.
4. Registrar resultado: **PASA** / **FALLA** (mensaje del navegador).

## Resultado

| Fecha | Dispositivo | Resultado | Notas |
|-------|-------------|-----------|-------|
| — | — | **PREPARADO** | Ejecutar en piloto; si FALLA → slice TLS o DEC amend |

## Si falla

Seguir DEC-056: slice TLS autofirmado o hosting `https://` en LAN.