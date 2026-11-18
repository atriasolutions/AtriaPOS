# pos_app — cliente Flutter POS barrio

## Tests

```powershell
cd apps\pos_app
flutter test
flutter test test/sale_flow_e2e_test.dart
# En Windows desktop (modo desarrollador activo para symlinks):
flutter test integration_test/sale_flow_test.dart -d windows
```

SLICE-6: flujo local-first con `packages/adapters` (Drift) y servicios `packages/core`.