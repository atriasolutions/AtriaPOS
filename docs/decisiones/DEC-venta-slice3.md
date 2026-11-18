# DEC — Venta SLICE-3 (sin DTE ni turno)

- **Estado:** Aceptado
- **Fecha:** 2026-11-18

| Tema | Decisión |
|------|----------|
| Precio línea | Congelado al agregar (`unitPriceClp`) |
| Pagos MVP | `EFECTIVO`, `OTRO` |
| Vuelto | `changeClp` = suma pagos − total |
| Stock | Descuento en checkout; movimiento `VENTA` en auditoría |
| DTE / turno | Fuera de slice; response checkout solo `saleId` + `totalClp` |
| Carro | `shiftId` / `userId` nullable |