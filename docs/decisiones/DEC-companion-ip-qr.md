# DEC-064 — IP del QR companion sin hot-reload TLS

**Estado:** ✅ Decidido (2026-11-26)  
**Slices:** 126–129  
**Relacionado:** DEC-063, SLICE-114.

## Decisión

- Cada `prepareCompanionQr` **vuelve a detectar** la IPv4 (salvo `COMPANION_LAN_HOST` fijo).
- El certificado TLS companion se emite al **arranque** del POS; si la IP cambia, el diálogo muestra **aviso** y el operador **reinicia el POS**.
- **No** se reinicia el servidor HTTPS en caliente en MVP (sin rebind TLS automático).

## Alternativa diferida

- Parar shelf, regenerar cert y volver a escuchar en la IP nueva sin cerrar el POS (slice futuro solo si piloto lo exige).