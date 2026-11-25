# DEC-063 — Companion Android con cámara nativa (LAN)

**Estado:** ✅ Decidido (2026-11-25)  
**Prioridad:** P0  
**Slices:** 116–121  
**Relación:** no reemplaza la PWA ni DEC-059. Es otro cliente del mismo contrato LAN.

## Decisión

- App Flutter Android en `apps/scanner_companion`.
- La cámara es nativa (`mobile_scanner`). No hace falta instalar una CA en el teléfono.
- El emparejamiento y el envío de códigos usan el contrato ya existente: enlace `https://{ip}:8765/c/{codigo}`, `POST .../companion/pair` y WebSocket `{"type":"scan","code":"..."}`.
- Al conectar, la app acepta el certificado TLS **solo del host** que viene en ese enlace.
- El modo (vender, ingreso, conteo) lo trae el QR del POS. La app no lo elige.
- La puerta de la app es la conexión LAN. El código BLE permanece en el repo y deja de ser la pantalla inicial.
- Piloto: APK instalado a mano. Sin Play Store en estas slices.

## Alternativas descartadas

- Instalar la CA de la caja en Android como camino principal.
- Túnel HTTPS público en esta tanda.
- API nueva solo para la app.

## Impacto

`apps/scanner_companion`, acceptance `slice_116` … `slice_121`, runbook del APK. El servidor del POS no cambia.
