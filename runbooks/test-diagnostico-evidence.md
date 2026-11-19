# Evidencia — Diagnóstico de pruebas (SLICE-36)

Registro reproducible. Informe maestro: [`docs/18-diagnostico-pruebas.md`](../docs/18-diagnostico-pruebas.md).

## Checklist

| Paso | Comando / acción | Resultado 2026-11-19 |
|------|------------------|------------------------|
| CI local | `.\scripts\ci-local.ps1` desde raíz | Verde (core 114, adapters 25, app 27) |
| Companion | `cd apps\scanner_companion && flutter test` | 1 test verde |
| Sensibles | `flutter test test/sii_checkout_evidence_ui_test.dart test/scanner_ble_*.dart` en `pos_app` | Verde ~23 s |
| Cobertura core | Ver §3 en doc 18 | **81,2 %** líneas |

## Conteos rápidos

```powershell
cd packages\core; dart test -r compact
cd packages\adapters; dart test -r compact
cd apps\pos_app; flutter test -r compact
```

## Cobertura core (copiar/pegar)

```powershell
cd packages\core
dart pub get
dart test --coverage=coverage
dart pub global activate coverage
dart pub global run coverage:format_coverage --lcov --in=coverage --out=coverage\lcov.info --packages=.dart_tool\package_config.json --report-on=lib
```

## Estado del slice

| Campo | Valor |
|-------|-------|
| Slice | SLICE-36 |
| SC | Diagnóstico (operativo) |
| Evidencia | Este archivo + `docs/18-diagnostico-pruebas.md` |
| Gate CI cobertura | **Propuesto, no activado** |