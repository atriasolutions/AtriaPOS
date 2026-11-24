# DEC-045 — Sin nombres de persona en el repositorio

**Estado:** ✅ Decidido (2026-11-24)  
**Slice:** SLICE-57

## Decisión

1. No commitear **nombres propios** (reales ni ficticios) en código, tests, docs ni runbooks.
2. Usar **roles de dominio**: Dueño, Cajero, Supervisor, Operador piloto.
3. Evidencia piloto en git: fecha + rol; identificación nominal solo **fuera del repo**.
4. Runbooks: rutas genéricas (`<raíz-del-repo>`), sin `Users\Nombre`.
5. Gate: [`scripts/check-no-person-names.ps1`](../scripts/check-no-person-names.ps1) en `ci-local` y CI GitHub.

## Permitido

- Marca Atria POS, Atria Solutions SpA, handles GitHub en URLs.
- Nombres de producto de prueba (Pan, Minimarket).
- Rol documental **operador** sin apellido.

## Impacto

- Lista `scripts/deny-person-names.txt`; extensible con PR.
- AGENTS.md y revisión pre-commit manual si el gate no cubre un caso.