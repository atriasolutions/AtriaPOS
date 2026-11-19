# Hito — merge MVP a `main`

Preparación para integrar la rama de trabajo (p. ej. `feat/slice-0-scaffold`) en `main` con evidencia de CI equivalente a local.

SLICE-29 alinea título PR (slices 0–28) y evidencia [`pr-merge-evidence.md`](pr-merge-evidence.md). SLICE-26: script + plantilla; SLICE-24: runbook base.

> Al cerrar un nuevo slice operativo, actualizar el título `gh pr create` y [`pr-body-mvp.md`](pr-body-mvp.md) con el último número de slice.

## Pre-requisitos

- Flutter **stable** (misma línea que [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)).
- Dart incluido con Flutter.
- **No** incluir en el diff: `.env`, certificados, `.pfx`, claves, `dart-define` con secretos.
- GitHub: [`github-remote-setup.md`](github-remote-setup.md) (`gh auth`, remoto `origin`).

## Suite local (= CI)

**Opción A** — desde la raíz del repositorio:

```powershell
.\scripts\ci-local.ps1
```

**Opción B** — mismos pasos que CI, manualmente:

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

Criterio: los tres bloques terminan en verde. Evidencia post SLICE-27: **114 + 25 + 26** tests (core + adapters + app). El workflow CI ejecuta el mismo orden sin contar tests individualmente.

## Checklist antes del PR

| Ítem | Hecho |
|------|-------|
| `git fetch` y revisar `git log main..HEAD` (alcance del PR) | ☐ |
| `git status` limpio (o solo cambios intencionados del hito) | ☐ |
| Suites locales verdes (`ci-local.ps1` o bloques anteriores) | ☐ |
| Sin archivos sensibles en `git diff --stat` | ☐ |
| [`docs/reporte-avances-mvp.md`](../docs/reporte-avances-mvp.md) al día | ☐ |
| [`docs/12b-matriz-verificacion-automatizacion.md`](../docs/12b-matriz-verificacion-automatizacion.md) revisada | ☐ |
| Piloto SII (`SC-080-03`) **pendiente** — no bloquea merge MVP con DTE fake | ☐ |
| Evidencia PR preparada — [`pr-merge-evidence.md`](pr-merge-evidence.md) | ☐ |

## Abrir PR (operador)

1. Actualizar la rama en remoto (si aplica):

   ```bash
   git push -u origin HEAD
   ```

2. Crear PR hacia `main` (ejemplo con `gh`, desde la raíz del repo):

   ```bash
   gh pr create --base main --title "MVP POS: slices 0-33" --body-file runbooks/pr-body-mvp.md
   ```

3. Verificar que el check **CI** en GitHub quede verde antes del merge.

4. Registrar URL y estado **ABIERTO** en [`pr-merge-evidence.md`](pr-merge-evidence.md).

## Post-merge

- Actualizar evidencia a **MERGED** en [`pr-merge-evidence.md`](pr-merge-evidence.md).
- Tag opcional de hito (ej. `mvp-2026-11`).
- Siguiente foco: [`tienda-piloto-indice.md`](tienda-piloto-indice.md) (demo, BLE, SII) o estabilización en `main`.