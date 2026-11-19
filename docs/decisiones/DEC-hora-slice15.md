# DEC — Hora SHOA (SLICE-15)

| Tema | Decisión |
|------|----------|
| Fuente | ntp.shoa.cl; fallback IP 200.54.149.19 UDP 123 |
| Persistencia | Tabla `clock_state` offset y degradado |
| UI | America/Santiago vía `formatChileDateTime` (UTC+presentación) |
| Offline | Reloj dispositivo + banner «reloj local» |