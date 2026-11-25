# 22 — Revisión siguiente · Bloque B — Companion web

**Estado:** **stub** — sin slices ni fechas; **planificación por slices habilitada** (SLICE-94 cerrado 2026-11-25).  
**Prerrequisito duro:** cumplido — plan Bloque A en [`21-plan-revision-operacion-productos.md`](21-plan-revision-operacion-productos.md) **cerrado** (SLICE-85…94); implementación Bloque A cerrada antes de abrir backlog B por slices.

---

## Objetivo (borrador)

Diseñar e implementar una **aplicación web** inspirada en el companion móvil existente (`apps/scanner_companion`), con cambios operativos que el cliente detallará en la **sesión de planificación Bloque B**.

**Punto de partida en repo:** companion Flutter Android + BLE periférico ([`apps/scanner_companion/lib/ble_peripheral.dart`](../apps/scanner_companion/lib/ble_peripheral.dart)); ingress hacia POS documentado en RNF-041 / SLICE-17–18.

---

## Alcance preliminar (solo orientación)

| Probable inclusión (a confirmar) | Fuera hasta planificar |
|----------------------------------|-------------------------|
| Escaneo desde navegador o web app emparejada con POS | Sustituir POS desktop |
| Reuso de protocolo / códigos hacia el núcleo | Bloque A (ingreso/inventario en app POS) |
| Despliegue y auth web (DEC futuro) | Integración Transbank |

**Detalle funcional:** pendiente del cliente en planificación Bloque B.

---

## Gate R4-B (futuro)

1. ~~Cerrar Gate R4-A y SLICE-94.~~ ✅ (2026-11-25).  
2. Workshop Bloque B: requisitos, stack web, frontera con POS (online/offline).  
3. Redactar **tabla de slices** en este documento (mín. objetivos, RF, DoD).  
4. Actualizar `10-plan-entregas.md` y acta.

**Regla de programa:** slices Bloque B aún **no abiertos** hasta tabla slices en este doc + filas en doc 10; prerrequisito Bloque A **cumplido** (SLICE-94).

---

## Próximo paso

Cuando el cliente indique que doc 21 está aprobado y decida abrir Bloque B, agendar planificación con:

- Canales de escaneo en web (cámara, HID, BLE bridge).  
- ¿Companion web reemplaza app Android o convive?  
- Hosting y seguridad (PIN, tienda, PII).

Hasta entonces, **este archivo no define SLICE-95+**.