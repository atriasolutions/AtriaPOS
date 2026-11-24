# DEC-051 — PDF etiquetas QR A4 (SLICE-81)

**Estado:** ✅ Decidido  
**Fecha:** 2026-11-24  
**RF:** RF-092

## Contexto

Operador necesita imprimir etiquetas con QR de productos sin capturas manuales.

## Decisión

1. Formato **PDF**, página **A4**.
2. Grilla fija inicial **3 columnas × 5 filas** (15 etiquetas por hoja).
3. Cada etiqueta: nombre acortado, imagen QR, payload legible (truncado si excede ancho).
4. Exportación de **código de barras** diferida a slice posterior.

## Consecuencias

- Dependencia `pdf` en `pos_app`.
- Tests de generación (bytes no vacíos, páginas según cantidad).