# 23c — Companion HTTPS · Respuestas (post Bloque B)

**Estado:** ✅ cerrado documentalmente (2026-11-25)  
**Base:** piloto en celular (USB tethering, cámara `unsupported` en HTTP) y decisiones DEC-059…062.  
**Código de producto:** no entra en SLICE-106. Slices 107–112 se abren uno a uno en Plan y, tras confirmar, en Agent.

---

## Respuestas

| # | Tema | Decisión |
|---|------|----------|
| 1 | Cámara | HTTPS local. Certificado creado por la caja. El celular instala la CA. |
| 2 | Si la cámara sigue bloqueada | Ingreso del código a mano, grande y claro. Visor vacío oculto. La cámara no bloquea el cierre. |
| 3 | QR | Enlace corto `https://{ip}:8765/c/{codigo}`. |
| 4 | Red | USB y Wi-Fi. El POS elige la IPv4 del enlace activo. |
| 5 | Alcance | Vender, Ingreso y Conteo. Fuera: tributario y backlog de caja. |
| 6 | Transporte previo | DEC-056 (HTTP) queda enmendado por DEC-059. Puerto **8765**. |

## Orden de slices

| Slice | Entrega | Modo |
|-------|---------|------|
| 106 | Estas decisiones | Este documento |
| 107 | `GET /c/{codigo}` y QR corto | Plan, luego Agent |
| 108 | Pantalla simple, sin visor | Plan, luego Agent |
| 109 | HTTPS, CA instalable, IP activa | Plan, luego Agent |
| 110 | Intento de cámara; si falla, solo manual | Plan, luego Agent |
| 111 | Estado “Celular conectado” y cortar sesión | Plan, luego Agent |
| 112 | Código llega a Vender, Ingreso y Conteo | Plan, luego Agent |
