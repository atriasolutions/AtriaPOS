# Migración de repositorio — Atria POS

De `pos-barrio-segmento-d` → **`mmb21894-ux/atria-pos`**. DEC: [`DEC-044-marca-atria-pos.md`](../docs/decisiones/DEC-044-marca-atria-pos.md).

## Repo canónico

| Campo | Valor |
|-------|-------|
| URL | `https://github.com/mmb21894-ux/atria-pos.git` |
| Visibilidad | Privado |
| Historial | Completo (mirror push) |
| Tags | Incluir `mvp-2026-11` |

## Pre-vuelo

| Ítem | Hecho |
|------|-------|
| `.\scripts\ci-local.ps1` verde | ☐ |
| SLICE-55 documentado en `main` o rama lista para push | ☐ |
| `gh auth status` OK | ☐ |

## Operador — crear remoto nuevo

```powershell
cd <raíz-repo>
gh repo create mmb21894-ux/atria-pos --private --description "Atria POS — comercio de barrio (Chile)"
git remote add atria https://github.com/mmb21894-ux/atria-pos.git
git push atria --all
git push atria --tags
```

## Alinear `origin` local

```powershell
git remote rename origin legacy-pos-barrio
git remote rename atria origin
git branch -u origin/main main
```

(URL legado: `https://github.com/mmb21894-ux/pos-barrio-segmento-d.git`)

## Archivar repositorio anterior

En GitHub: **Settings → Archive repository**, o:

```powershell
gh repo archive mmb21894-ux/pos-barrio-segmento-d --yes
```

Opcional: README final en repo archivado con texto “Movido a https://github.com/mmb21894-ux/atria-pos”.

## Checklist por PC (Karina, etc.)

```powershell
git remote set-url origin https://github.com/mmb21894-ux/atria-pos.git
git fetch origin
git checkout main
git pull
cd apps\pos_app; flutter pub get
```

## CI

Workflow [`.github/workflows/ci.yml`](../.github/workflows/ci.yml) no depende del nombre del repo; tras el primer push, verificar run en GitHub Actions.

## Evidencia

Registrar en [`pr-merge-evidence.md`](pr-merge-evidence.md) sección SLICE-55.