# DEC-066 — Pausa del código vendedor en checkout

**Estado:** ✅ Decidido (2026-11-27)  
**Prioridad:** P0  
**Slices:** 144

## Decisión

- Atria POS deja de incluir `sellerCodeCheckout` para poder cobrar sin planilla cargada.
- `collaboratorPlanilla` permanece. Reactivar el requisito es volver a agregar la feature a la plantilla.
- Mientras esté en pausa, un `sellerCode` informado no se valida ni se persiste.
