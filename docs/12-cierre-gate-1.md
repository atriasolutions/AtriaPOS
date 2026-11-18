# 12 — Cierre Gate 1 (confirmación antes de codear)

**Estado:** 🟢 Confirmado (2026-11-18) — listo para SLICE-0 tras revisión menor opcional.

## Resumen ejecutivo

Producto: **POS segmento D** (almacén de barrio), **local-first**, TDD en `packages/core`, UI Flutter, boleta electrónica con cola offline.

## Decisiones que debes confirmar

| # | Tema | Propuesta | Alternativa |
|---|------|-----------|-------------|
| D1 | Stack | Flutter + Dart core | Solo web |
| D2 | MVP sin backend | Sí, SQLite local | API desde día 1 |
| D3 | Stock al fallar DTE | **Opción A**: descontar + `PENDIENTE_DTE` | Opción B: solo con DTE OK |
| D4 | Nombre código | `pos_barrio` | Otro |
| D5 | Fiado en MVP | Postergar (SLICE-7+) | Incluir en MVP |
| D6 | Tests descripción | Español en escenarios | Inglés |

## Criterio de hecho Gate 1

- [x] Alcance MVP aceptado (doc 00).
- [x] RF [M] aceptados o ajustados (doc 04).
- [x] Contratos API v0 aceptados (doc 07).
- [x] Decisiones registradas abajo (D1–D6).
- [x] Repositorio Git inicializado (Gate 0).
- [x] Autorización para iniciar **SLICE-0** (scaffold sin lógica de negocio).

### Decisiones confirmadas

| # | Decisión |
|---|----------|
| D1 | Flutter + Dart `packages/core` |
| D2 | **Solo local SQLite** (sin backend en MVP) |
| D3 | **Opción A**: descontar stock y `PENDIENTE_DTE` si falla SII |
| D4 | Nombre código `pos_barrio` (pendiente validar en scaffold) |
| D5 | Fiado postergado post-MVP |
| D6 | Escenarios de test en español |
| D7 | Kora solo como **complemento** opcional; núcleo POS **no depende** de Kora (doc 14) |

## Próximo paso tras Gate 1

1. ~~`git init`~~ (hecho).
2. Ejecutar [**plan de definición**](15-plan-definicion-pre-implementacion.md) y cerrar **P0** en [`16-registro-decisiones.md`](16-registro-decisiones.md).
3. Firmar [**Gate 2**](17-cierre-gate-2.md).
4. `SLICE-0` scaffold (paralelo si no fija DEC abiertos).
5. `SLICE-1`: primer test `crear producto válido` en rojo.

## Confirmación

Responde en chat, por ejemplo:

```text
Gate 1: OK
D1-D4: propuesta
D3: A
D5: postergar
D6: español
```

O indica cambios por RF-ID.

---

*Atria Gate 1 — no se implementa lógica de producto sin esta confirmación explícita.*