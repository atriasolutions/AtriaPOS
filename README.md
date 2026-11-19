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
# Paridad con CI (desde la raíz del repo)
.\scripts\ci-local.ps1

# App
cd apps\pos_app
flutter pub get
flutter test
flutter run -d windows
```

Detalle por paquete: [`runbooks/merge-mvp-hito.md`](runbooks/merge-mvp-hito.md).

## Estado

**SLICE-26:** MVP **listo para PR** a `main` (kit merge; integración manual del operador). Slices recientes **21–25**: certificado SII, drift reportes/auditoría, cierre sin turno, prep piloto SII. Plantilla PR: [`runbooks/pr-body-mvp.md`](runbooks/pr-body-mvp.md). Reporte: [`docs/reporte-avances-mvp.md`](docs/reporte-avances-mvp.md).

CI en [`.github/workflows/ci.yml`](.github/workflows/ci.yml). Matriz: [`docs/12b-matriz-verificacion-automatizacion.md`](docs/12b-matriz-verificacion-automatizacion.md). Plan: [`docs/10-plan-entregas.md`](docs/10-plan-entregas.md).