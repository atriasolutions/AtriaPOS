# Pre-vuelo GitHub — remoto y `gh` (SLICE-30 / SLICE-31)

Requisito antes de `git push` y `gh pr create`. No incluir tokens en el repo.

## 1. Autenticación GitHub CLI

```powershell
gh auth login -h github.com -p https -w
gh auth status
```

## 2. Remoto `origin`

Si no hay remoto (`git remote -v` vacío):

**Opción A** — repositorio existente:

```powershell
git remote add origin https://github.com/<org>/<repo>.git
```

**Opción B** — crear repo privado y empujar (requiere `gh` autenticado):

```powershell
gh repo create <nombre-repo> --private --source=. --remote=origin --push
```

## 3. Rama `main` en remoto

Primera integración: asegurar que exista `main` en GitHub (vacía o con README). El PR sale de `feat/slice-0-scaffold` hacia `main`.

## 4. Continuar

Seguir [`merge-mvp-hito.md`](merge-mvp-hito.md) y registrar en [`pr-merge-evidence.md`](pr-merge-evidence.md).