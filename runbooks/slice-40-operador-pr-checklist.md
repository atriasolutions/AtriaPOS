# SLICE-40 — Checklist operador: abrir PR (SC-030-01)

Modelo **operador primero**: el agente no ejecuta `gh auth login`. Tú publicas; luego pegas la **URL del PR** en el chat para cerrar evidencia.

Kit: [`pr-body-mvp.md`](pr-body-mvp.md) | Evidencia: [`pr-merge-evidence.md`](pr-merge-evidence.md) | Pre-vuelo: [`github-remote-setup.md`](github-remote-setup.md)

## 1. Pre-vuelo (tu PowerShell)

| Paso | Comando | Hecho |
|------|---------|-------|
| Sesión gh | `gh auth status` | ☐ |
| Remoto | `git remote -v` muestra `origin` | ☐ |
| Rama | `feat/slice-0-scaffold`, `git status` limpio | ☐ |
| CI local | `.\scripts\ci-local.ps1` verde | ☐ |

## 2. Publicar y crear PR

```powershell
cd <raíz-del-repo>
git push -u origin HEAD
gh pr create --base main --head feat/slice-0-scaffold `
  --title "MVP POS: slices 0-38" `
  --body-file runbooks/pr-body-mvp.md
```

Anotar:

- URL del PR: `________________________________________`
- HEAD (`git rev-parse --short HEAD`): `________`
- Fecha: `________`

## 3. Entregar al agente

En el chat de Cursor, envía un mensaje con:

1. La **URL completa** del PR  
2. (Opcional) HEAD y si el check **CI** en GitHub ya está verde

El agente actualizará `pr-merge-evidence.md` a **ABIERTO**, marcará **SC-030-01** en `12b` y hará commit `feat(slice-40): evidencia PR ABIERTO SC-030-01.`

## 4. No hacer en este slice

- `gh pr merge` (reservado SLICE-41)
- Commitear tokens, `.env`, certificados