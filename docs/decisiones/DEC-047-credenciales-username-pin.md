# DEC-047 — Credenciales username/PIN y UUID usuario (SLICE-60)

**Estado:** ✅ Decidido  
**Fecha:** 2026-11-24  
**RF:** RF-080

## Contexto

Revisión 2 requiere perfil completo de usuario y política de credenciales sin ñ.

## Decisión

1. **Login** solo con `username` + PIN (no `userId` legible en login).
2. **`id` interno** del usuario = UUID v4 generado en servidor al crear o en bootstrap.
3. **`username` y PIN** no admiten `ñ`/`Ñ`; nombre y apellido sí admiten español Chile.
4. Migración SQLite v13: `username = id` para filas legadas revisión 1.

## Consecuencias

- API-006 y bootstrap actualizados (doc 07).
- Sesión `AuthSession.userId` sigue siendo UUID interno.