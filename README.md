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
flutter run -d windows
```

## Estado

**SLICE-0:** scaffold — sin lógica de negocio.

Siguiente: cerrar DEC P0 en [`docs/16-registro-decisiones.md`](docs/16-registro-decisiones.md) y **SLICE-1** (catálogo / API-001).