# DEC-059 — Companion LAN en HTTPS local

**Estado:** ✅ Decidido (2026-11-25)  
**Prioridad:** P0  
**Slices:** 109  
**Enmienda:** sustituye el transporte HTTP de DEC-056 para el companion. El puerto fijo sigue en **8765**.

## Decisión

- El servidor embebido del companion escucha **HTTPS** en la red local.
- La caja genera una **CA local** y un certificado para la IP anunciada.
- El celular **instala** esa CA para no repetir la advertencia del navegador.
- Sigue el bind en todas las interfaces. Sin exposición a Internet.

## Alternativas descartadas

- Seguir en HTTP (la cámara del navegador queda `unsupported`).
- App Android nativa en lugar de la PWA.

## Impacto

`CompanionLanServer`, configuración LAN del POS, página de instalación del certificado, runbook de piloto.

---

# DEC-060 — Enlace corto del QR

**Estado:** ✅ Decidido (2026-11-25)  
**Prioridad:** P0  
**Slices:** 107

## Decisión

- El QR lleva un enlace corto: `https://{ip}:8765/c/{codigo}`.
- `GET /c/{codigo}` resuelve tienda, modo y código de emparejamiento y abre la PWA.
- Se deja de armar la query larga (`storeId`, `mode`, `pairingCode`) en el QR.

## Alternativas descartadas

- Mantener la URL completa y copiarla a mano cuando el lector la corta.

## Impacto

`companion_lan_server.dart`, `companion_qr_panel.dart`, contrato en doc 07 al implementar el slice.

---

# DEC-061 — Cámara opcional; ingreso manual si falla

**Estado:** ✅ Decidido (2026-11-25)  
**Prioridad:** P0  
**Slices:** 108, 110

## Decisión

- Se intenta la cámara sobre HTTPS.
- Si el navegador la bloquea (`unsupported` u otro fallo), se oculta el visor vacío.
- El camino de caja es **escribir el código**, con campo grande y un botón de envío.
- La cámara no es requisito para cerrar la tanda.

## Alternativas descartadas

- No cerrar el companion hasta leer un código con la cámara.

## Impacto

`apps/companion_web`: copia en español de caja, sin UUID de tienda ni botón Emparejar cuando ya hay sesión.

---

# DEC-062 — USB y Wi-Fi, misma IP activa

**Estado:** ✅ Decidido (2026-11-25)  
**Prioridad:** P1  
**Slices:** 109, 112

## Decisión

- USB tethering y Wi-Fi usan el mismo mecanismo.
- El POS elige la IPv4 del enlace activo (RNDIS/USB o Wi-Fi) y esa dirección va en el QR.
- Puerto fijo **8765**.

## Alternativas descartadas

- Soportar solo el cable USB en esta tanda.

## Impacto

`companion_lan_config.dart`. Fuera de alcance: tributario y backlog de caja (efectivo, promociones, fiado, impresora, respaldo).
