# Companion Android — UX v2 (operador)

**Estado:** ✅ Brief cerrado (SLICE-139)  
**Ámbito:** `apps/scanner_companion` (LAN). BLE en `main.dart` no es puerta de entrada.  
**Incidente origen:** 2026-11-26 — confusión empareje vs escaneo de productos.

## Decisiones UI (confirmadas)

| Tema | Decisión |
|------|----------|
| CTA desconectado | **Vincular con la caja**, inferior, ancho completo, `SafeArea` |
| Flujo vincular | Cámara **al instante** (QR POS), sin pantalla intermedia |
| Avanzado desconectado | **Más opciones** debajo del CTA; pegar enlace + usar enlace |
| CTA conectado | **Escanear** en el mismo hueco inferior |
| Conectado oculta | Sin empareje ni URL |
| Desconectar | Solo **ícono** logout, arriba derecha |
| AppBar conectado | Título **En la caja** + subtítulo modo (Vender, etc.) |
| Feedback envío OK | Solo texto **Listo:** / **Último:** |
| Manual productos | Expansión **Escribir código** |
| Armed | DEC-065 — mantener |

**Intro desconectado:** «Use el botón inferior para vincular; después escanee productos en la caja.»

## Arquitectura

- [`CompanionLanShell`](../apps/scanner_companion/lib/companion_lan_shell.dart): fases `disconnected | connected` sin `push` al visor.
- Keys de prueba estables: `companion_lan_read_qr_button`, `companion_lan_send_scan_button`, `companion_lan_more_options`, etc.

## Slices de entrega

| Slice | Contenido |
|-------|-----------|
| 139 | Este documento |
| 140 | Layout desconectado |
| 141 | Layout conectado |
| 142 | Shell + regresión |
| 143 | Piloto / runbook |

## Fuera de alcance

Día cero instalador, PWA layout, vibración/beep, auto-send.

## Referencia

Store operador: `atria-companion-android-ux-v2-operador.md`