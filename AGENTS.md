# AGENTS.md — Atria POS

## Contexto

**Atria POS** — POS para **comercio de barrio** (Chile), perfil segmento D. Definición en `docs/`. Desarrollo **TDD vertical**. Repo canónico: `atriasolutions/AtriaPOS` (DEC-046).

## Gates

1. **Git obligatorio** antes de código de producto.
2. **Gate 1:** confirmado en `docs/12-cierre-gate-1.md`.
3. **Gate 2:** cerrar DEC P0 en `docs/16-registro-decisiones.md` + `docs/17-cierre-gate-2.md` antes de SLICE-1.
4. Leer `docs/09-estrategia-tdd.md` antes de cada slice.
5. Plan definición: `docs/15-plan-definicion-pre-implementacion.md`.
6. **Revisión 2:** `docs/20-plan-revision-2-atria-pos.md` — **Gate R2** (SLICE-59) antes de SLICE-60+.

## Orden de lectura

`docs/README.md` → requisitos 04–05 → contratos `07` → slice actual en `10`. Si slice ≥ 59: doc `20` + acta `19`.

## Reglas de implementación

- Tests de **comportamiento** contra API/casos de uso públicos (`packages/core`).
- Un slice a la vez; no avanzar con tests rojos del slice actual.
- Mínimo diff; sin features fuera de RF del slice.
- Docs español Chile.
- **Al cerrar cada slice:** commit obligatorio (ver `.cursor/rules/slice-cierre-commit.mdc`). Otros commits intermedios solo si el usuario lo pide.
- Certificados SII / secretos: nunca en repo ni chat.
- Sin nombres propios en git (DEC-045); roles y `scripts/check-no-person-names.ps1`.
- Núcleo POS autónomo; Kora solo complementos opcionales (`docs/14-nucleo-y-complementos-kora.md`).
- Cobertura objetivo ≥ 80 % en `packages/core` (post SLICE-4).

## Stack (propuesto)

Flutter app + `packages/core` (dominio Dart). Ver `docs/06-arquitectura.md`.

## Comandos (cuando exista proyecto)

```bash
dart test packages/core
flutter test apps/pos_app
```