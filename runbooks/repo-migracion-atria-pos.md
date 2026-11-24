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

## Checklist por cada PC de desarrollo

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

---

## Corte org Atria Solutions (SLICE-58)

De `mmb21894-ux/atria-pos` → **`atriasolutions/AtriaPOS`**. DEC: [DEC-046](../docs/decisiones/DEC-046-repo-org-atriasolutions.md).

### Destino

| Campo | Valor |
|-------|-------|
| URL | `https://github.com/atriasolutions/AtriaPOS.git` |
| Visibilidad | **Privado** (ajustar en GitHub antes del push si el repo estaba público) |
| Mirror | `git push org --all` y `git push org --tags` |

### Comandos

```powershell
cd <raíz-del-repo>
# Pre: gh repo edit atriasolutions/AtriaPOS --visibility private  (requiere admin org)
git remote add org https://github.com/atriasolutions/AtriaPOS.git
git push org --all
git push org --tags
git remote rename origin legacy-atria-pos-personal
git remote add origin https://github.com/atriasolutions/AtriaPOS.git
git branch -u origin/main main
```

### Archivar remoto personal intermedio

1. README: «Movido a https://github.com/atriasolutions/AtriaPOS».
2. `gh repo archive mmb21894-ux/atria-pos --yes`

### PCs de desarrollo

```powershell
git remote set-url origin https://github.com/atriasolutions/AtriaPOS.git
git fetch origin
git checkout main
git pull
```