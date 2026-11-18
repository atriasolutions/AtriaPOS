# DEC-033 — CI GitHub Actions (SLICE-11)

## Decisión

Pipeline **ubuntu-latest** en cada push/PR a `main` y `feat/**`:

1. `dart test` en `packages/core`
2. `dart test` en `packages/adapters`
3. `flutter test` en `apps/pos_app`

Flutter **stable** vía `subosito/flutter-action` (SDK ≥ 3.14 según `pubspec`).

## Alcance excluido

- Sin secretos SII ni certificados en CI.
- Sin `integration_test` en dispositivo; smoke = widget tests en `apps/pos_app`.
- Build Windows/Android no obligatorio en CI (desarrollo local).

## Consecuencias

Regresión detectada en PR antes de merge; matriz 12b referencia automatización app/core.