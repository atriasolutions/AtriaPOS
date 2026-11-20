# DEC-005 — API in-process vs HTTP tests

- **Estado:** Aceptado (retroactivo SLICE-45)
- **Fecha:** 2026-11-20
- **Prioridad:** P0
- **Relacionado:** [`docs/07-contratos-api-publica.md`](../07-contratos-api-publica.md), SLICE-1+, DEC-034

## Contexto

El MVP corre local-first sin servidor HTTP; los contratos API-00x deben ser testeables sin levantar red.

## Decisión

1. **Fachada API:** servicios en `packages/core/lib/api/*` (`SaleService`, `ShiftService`, etc.) construyen casos de uso con repositorios inyectados.
2. **Resultado HTTP-like:** `ApiResult<T>` con códigos alineados al doc 07 (`api_result.dart`).
3. **Tests de contrato:** `packages/core/test/api/*` invocan servicios in-process con fakes/memory/drift en tests de adaptadores.
4. **App Flutter:** `PosComposition` cablea la misma superficie (DEC-034 / [`DEC-ui-slice6.md`](DEC-ui-slice6.md)); sin capa REST en MVP.

## Alternativas descartadas

| Alternativa | Motivo |
|-------------|--------|
| Servidor HTTP + integration HTTP desde SLICE-0 | Sobrecoste para tienda un dispositivo |
| Solo tests de dominio sin ApiResult | Pierde trazabilidad con doc 07 |

## Impacto

- Estrategia TDD en [`docs/09-estrategia-tdd.md`](../09-estrategia-tdd.md)
- CI: `dart test packages/core` + matriz 12b columna Core/API

## Verificación

- Suites `packages/core/test/api/*` en `ci-local.ps1`.