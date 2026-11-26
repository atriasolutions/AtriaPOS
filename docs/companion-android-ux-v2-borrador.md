# Companion Android UX v2 — borrador operador

**Estado:** sustituido por [`companion-android-ux-v2.md`](companion-android-ux-v2.md) (SLICE-139)  
**Fuente:** incidente piloto + requisitos operador (store personal `atria-companion-android-ux-v2-operador.md`)

## Resumen

Reorganizar `scanner_companion` para **una mano**: CTA inferior (vincular → escanear), opciones de conexión ocultas en trabajo, salida discreta arriba a la derecha. Cualquier slice futuro debe **confirmar UI** con el operador antes de implementar.

## Confirmado operador (2026-11-26)

- Desconectar: **solo ícono** arriba derecha.
- CTA inferior desconectado: **«Vincular con la caja»**.
- Avanzado desconectado: **«Más opciones»** bajo el botón inferior.
- Manual productos: expansión discreta **sí**.

## Fuera de alcance hasta nuevo slice

No modificar código en este documento; solo ancla para planificación v2.

## Relación

- DEC-065 (armed scan) — conservar salvo decisión contraria en fase A.
- Slices 131–138 — referencia histórica; v2 puede re-layout sin revertir contrato LAN.