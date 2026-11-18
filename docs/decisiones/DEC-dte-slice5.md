# DEC — DTE SLICE-5 (fake)

- **Estado:** Aceptado
- **Fecha:** 2026-11-18

| DEC | Decisión |
|-----|----------|
| 019 | Boleta tipo **39**; payload desde `Sale` |
| 020 | `FakeDteGateway` in-process; SII real en SLICE-8 |
| 022 | Cola local; retry manual API-005; sin TTL en S5 |
| 023 | Una emisión por `saleId` (idempotente si ya EMITIDA) |