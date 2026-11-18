# DEC — RF-010 catálogo UI (SLICE-13)

| Tema | Decisión |
|------|----------|
| Alcance v1 | Solo **crear** producto desde app; sin editar ni eliminar |
| API | Consumo directo de API-001 `ProductService.createProduct` |
| Barcode duplicado | CONFLICTO (DEC-010); mensaje API en SnackBar |
| Stock inicial | Campo opcional en UI (RF-012); default 0 |
| Permiso | `configurarCatalogo` → supervisor y dueño |