# POS barrio (segmento D)

Punto de venta para comercio de barrio en Chile. Documentación en [`docs/README.md`](docs/README.md).

## Requisitos

- Flutter 3.50+ (`C:\src\flutter` o en `PATH`)
- Windows desktop habilitado para `flutter run -d windows`

## Estructura

```text
apps/pos_app/       # UI Flutter
packages/core/      # Dominio y casos de uso (Dart puro)
packages/adapters/  # SQLite, DTE, integraciones (futuro)
```

## Comandos

```powershell
# Tests núcleo
cd packages\core
dart pub get
dart test

# Tests adaptadores
cd ..\adapters
dart pub get
dart test

# App (desde raíz del repo)
cd ..\..\apps\pos_app
flutter pub get
flutter test
flutter run -d windows
```

## Estado

**SLICE-24:** hito prep merge a `main` (runbook + reporte). Últimos slices de producto: **20–23** (auditoría, certificado SII, drift reportes, cierre sin turno). Ver [`docs/reporte-avances-mvp.md`](docs/reporte-avances-mvp.md) y [`runbooks/merge-mvp-hito.md`](runbooks/merge-mvp-hito.md).

CI en [`.github/workflows/ci.yml`](.github/workflows/ci.yml). Matriz: [`docs/12b-matriz-verificacion-automatizacion.md`](docs/12b-matriz-verificacion-automatizacion.md). Plan: [`docs/10-plan-entregas.md`](docs/10-plan-entregas.md).