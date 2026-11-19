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

## Tienda piloto

Ruta operativa unificada (demo fake, BLE, SII, PR opcional): [`runbooks/tienda-piloto-indice.md`](runbooks/tienda-piloto-indice.md). Evidencia: [`runbooks/tienda-piloto-evidencia.md`](runbooks/tienda-piloto-evidencia.md).

## Estado

**SLICE-35:** piloto SII — botón **Copiar sale_id** tras checkout. Índice: [`runbooks/sii-piloto-indice.md`](runbooks/sii-piloto-indice.md). Aceptación: [`test/acceptance/slice_35_sii_copy_sale_id.md`](test/acceptance/slice_35_sii_copy_sale_id.md). PR MVP: [`runbooks/pr-merge-evidence.md`](runbooks/pr-merge-evidence.md). Reporte: [`docs/reporte-avances-mvp.md`](docs/reporte-avances-mvp.md).

CI en [`.github/workflows/ci.yml`](.github/workflows/ci.yml). Matriz: [`docs/12b-matriz-verificacion-automatizacion.md`](docs/12b-matriz-verificacion-automatizacion.md). Plan: [`docs/10-plan-entregas.md`](docs/10-plan-entregas.md).