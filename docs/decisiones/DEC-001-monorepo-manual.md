# DEC-001 — Monorepo manual (sin Melos en SLICE-0)

- **Estado:** Aceptado
- **Fecha:** 2026-11-18
- **Prioridad:** P0
- **Relacionado:** SLICE-0, F1-1

## Contexto

Se necesita estructura multi-paquete (`apps/`, `packages/`) sin añadir complejidad de tooling en la primera slice.

## Opciones consideradas

| Opción | Pros | Contras |
|--------|------|---------|
| Melos | Scripts unificados, bootstrap | Dependencia extra, curva SLICE-0 |
| Manual path deps | Simple, explícito | Scripts repetidos en README |

## Decisión

Monorepo **manual** con `path:` en `pubspec.yaml`. Reevaluar Melos al crecer el número de paquetes.

## Consecuencias

- Comandos documentados en README raíz.
- Cada package corre `dart pub get` / `dart test` por separado.