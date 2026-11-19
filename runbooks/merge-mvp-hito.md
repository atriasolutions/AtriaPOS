# Hito — merge MVP a `main`

Preparación para integrar la rama de trabajo (p. ej. `feat/slice-0-scaffold`) en `main` con evidencia de CI equivalente a local.

## Pre-requisitos

- Flutter **stable** (misma línea que [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)).
- Dart incluido con Flutter.
- **No** incluir en el diff: `.env`, certificados, `.pfx`, claves, `dart-define` con secretos.

## Suite local (= CI)

Desde la raíz del repositorio:

```powershell
cd packages\core
dart pub get
dart test

cd ..\adapters
dart pub get
dart test

cd ..\..\apps\pos_app
flutter pub get
flutter test
```

Criterio: los tres comandos terminan en verde. Evidencia SLICE-24: **114 + 25 + 24** tests (core + adapters + app) al 2026-11-19.

## Checklist antes del PR

| Ítem | Hecho |
|------|-------|
| `git status` limpio (o solo cambios intencionados del hito) | ☐ |
| Suites locales verdes (bloque anterior) | ☐ |
| Sin archivos sensibles en `git diff --stat` | ☐ |
| [`docs/reporte-avances-mvp.md`](../docs/reporte-avances-mvp.md) al día | ☐ |
| [`docs/12b-matriz-verificacion-automatizacion.md`](../docs/12b-matriz-verificacion-automatizacion.md) revisada | ☐ |
| Piloto SII (`SC-080-03`) **pendiente** — no bloquea merge MVP con DTE fake | ☐ |

## Abrir PR (operador)

1. Actualizar la rama en remoto (si aplica):

   ```bash
   git push -u origin HEAD
   ```

2. Crear PR hacia `main` (ejemplo con `gh`):

   ```bash
   gh pr create --base main --title "MVP POS: slices 0-23" --body-file pr-body.md
   ```

3. Cuerpo sugerido para `pr-body.md`:

   - Resumen: núcleo MVP operativo (tienda, roles, venta, turno, DTE fake/replay, reportes, auditoría, certificado consultable).
   - Tests: 114 core + 25 adapters + 24 app.
   - Matriz: [`docs/12b`](../docs/12b-matriz-verificacion-automatizacion.md).
   - Pendiente producción fiscal: [`runbooks/sii-cert-pilot-evidence.md`](sii-cert-pilot-evidence.md).
   - CI: workflow `CI` en push/PR a `main` y `feat/**`.

4. Verificar que el check **CI** en GitHub quede verde antes del merge.

## Post-merge

- Tag opcional de hito (ej. `mvp-2026-11`).
- Siguiente foco: piloto certificación SII o PR de estabilización según prioridad de negocio.