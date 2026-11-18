# DEC — UI SLICE-6

- **Estado:** Aceptado
- **Fecha:** 2026-11-18

| Tema | Decisión |
|------|----------|
| DEC-034 esbozo | Composición manual `PosComposition` en `pos_app`; sin get_it/riverpod en S6 |
| Tienda demo | `storeId` fijo `tienda_demo` |
| Persistencia | Drift para catálogo, ventas, turno, cola DTE; carrito in-memory |
| DTE en demo | `FakeDteGateway` éxito por defecto |
| Idioma UI | Español Chile |
| Smoke E2E | Windows en dev; widgets Material multiplataforma |
| Carrito volátil | Aceptado en S6; persistir carrito en slice posterior |