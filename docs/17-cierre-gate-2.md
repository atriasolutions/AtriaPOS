# 17 — Cierre Gate 2 (definición completa pre-implementación núcleo)

**Estado:** 🟡 Abierto — completar tras [`15-plan-definicion-pre-implementacion.md`](15-plan-definicion-pre-implementacion.md).

## Propósito

Gate 1 autorizó **alcance y principios**. Gate 2 autoriza **implementación del núcleo** (SLICE-1 en adelante) con decisiones técnicas P0 cerradas.

## Criterios de hecho

### A. Registro de decisiones

- [ ] Todos los DEC **P0** en estado ✅ en [`16-registro-decisiones.md`](16-registro-decisiones.md)
- [ ] ADRs creados para DEC P0 con alternativas documentadas
- [ ] Excepciones pospuestas registradas en `11-riesgos-y-supuestos.md` con aceptación explícita

### B. Documentación técnica

- [ ] [`08b-esquema-sqlite-v1.md`](08b-esquema-sqlite-v1.md) publicado *(o sección en 08)*
- [ ] Contratos [`07`](07-contratos-api-publica.md) con errores y payloads sin TBD en rutas [M]
- [ ] [`04`](04-requisitos-funcionales.md) con columna `nucleo|complemento` en RF
- [ ] Escenarios acceptance borrador para SLICE 1–5 en `test/acceptance/`

### C. Fiscal (mínimo para continuar a SLICE-5)

- [ ] DEC-019…023 decididos (DTE MVP, adaptador, cola, idempotencia)
- [ ] Runbook borrador certificación SII *(puede ser doc separado `runbooks/sii-cert.md`)*

### D. Verificación estratégica

- [ ] Revisión doc [`14`](14-nucleo-y-complementos-kora.md): ningún RF [M] marcado como complemento
- [ ] Workshop W1–W2 realizados o actas sustitutas en ADRs

## Autorización

Tras marcar lo anterior, confirmar en chat:

```text
Gate 2: OK — autorizo SLICE-1 TDD
```

## Qué sigue sin bloquear Gate 2

- SLICE-0 scaffold (estructura vacía, CI) puede avanzar en paralelo si no fija DEC abiertos.
- Fase 6 (wireframes) puede cerrarse antes de SLICE-6, no antes de SLICE-1.

## Gate 2 mínimo catálogo (SLICE-1)

Cerrado para catálogo: DEC-002, 003, 006–010, 016–017; `08b` tabla `products`; `test/acceptance/slice_01_catalogo.md`.

Pendiente Gate 2 completo: DEC fiscal 019–023, resto P0, contratos sin TBD en rutas venta.

---

## Retroactivo SLICE-45 (2026-11-20)

Cierre documental post-MVP de decisiones ya implementadas (sin cambio de código):

| DEC | ADR |
|-----|-----|
| DEC-004 Transacción checkout | [`decisiones/DEC-004-checkout-transaccion.md`](decisiones/DEC-004-checkout-transaccion.md) |
| DEC-005 API in-process | [`decisiones/DEC-005-api-in-process.md`](decisiones/DEC-005-api-in-process.md) |
| DEC-011 Carro / turno | [`decisiones/DEC-011-carro-turno.md`](decisiones/DEC-011-carro-turno.md) |
| DEC-012 Medios de pago | [`decisiones/DEC-012-medios-pago.md`](decisiones/DEC-012-medios-pago.md) |

- Aceptación: [`test/acceptance/slice_45_gate2_dec.md`](../test/acceptance/slice_45_gate2_dec.md)
- **Este documento (17) sigue 🟡 Abierto** — checklist A–D completo no marcado; MVP opera con Gate 2 parcial.

---

*Firmas / fecha: pendiente*