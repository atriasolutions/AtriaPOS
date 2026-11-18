# 02 — Visión y principios

## Visión

**El POS más simple y confiable para el comercio de barrio chileno**: caja clara, boleta en regla, stock que se entiende sin manual.

## Principios de producto

1. **Mostrador primero**: cada pantalla debe servir con una mano ocupada.
2. **Menos campos**: defaults inteligentes; el dueño configura, el cajero ejecuta.
3. **Fallar con mensaje claro** (español, acción sugerida).
4. **Offline honesto**: si no se puede emitir al SII, el sistema **no miente** (estado explícito + reintento).
5. **Núcleo autónomo**: el POS básico funciona sin Kora; Kora solo como **complemento** opcional (`docs/14-nucleo-y-complementos-kora.md`).

## Principios técnicos (pre-code)

1. **TDD vertical**: un comportamiento → test → implementación mínima → refactor.
2. **API pública estable**: la UI consume la misma superficie que los tests de integración.
3. **Dominio sin framework**: reglas de negocio testeables sin Flutter/SQLite.
4. **Modular monolith** en v1 (un deploy, bounded contexts claros).
5. **Sin secretos en repo**: certificados y claves SII solo en entorno seguro.
6. **Complementos en adaptadores**: Kora y terceros detrás de puertos opcionales; `NoOp` por defecto en tests del núcleo.

## Stack propuesto (sujeto a confirmación Gate 1)

| Capa | Propuesta | Motivo |
|------|-----------|--------|
| Cliente | Flutter (stable) | Ya instalado en entorno; tablet/teléfono |
| Dominio + aplicación | Dart puro (`packages/core`) | Tests unitarios rápidos |
| Persistencia local | SQLite + drift/sqflite | Offline |
| Backend MVP | API REST (Dart Frog o Node — **pendiente decisión**) | Sync multi-dispositivo futuro |
| DTE | Puerto `DteGateway` + adaptador SII mock → certificación | TDD sin red al inicio |

**[INFERIDO]** MVP puede arrancar **local-first** (solo dispositivo) y agregar sync en slice posterior.