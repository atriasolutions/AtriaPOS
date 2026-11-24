# DEC-050 — Cambio de sesión con caja cerrada (SLICE-82)

**Estado:** ✅ Decidido  
**Fecha:** 2026-11-24  
**RF:** RF-093

## Contexto

Piloto tienda requiere cambiar usuario en el mismo terminal sin ambigüedad de turno ni carrito.

## Decisión

1. **Cambiar sesión** solo si no hay turno abierto en la tienda.
2. Implementación: `SessionProvider.clear()` tras validar precondición.
3. **Carrito** en UI no persiste entre sesiones; al completar cambio se reinicia con aviso breve.
4. Sesión **expirada** (`SESION_EXPIRADA`): pantalla o flujo con botón **Iniciar sesión**; sin operación privilegiada hasta re-login.

## Consecuencias

- Caso de uso `EndSession` en `packages/core`.
- `AuthService.endSession` en API pública (doc 07).