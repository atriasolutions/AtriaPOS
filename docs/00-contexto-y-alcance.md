# 00 — Contexto y alcance

## Problema

Micro y pequeños comercios de barrio (almacenes, botillerías, minimarkets) operan con **caja manual**, **Excel** o herramientas genéricas. Necesitan:

- Vender rápido en mostrador.
- Emitir **boleta electrónica** válida ante el SII.
- Controlar **stock y márgenes** sin complejidad de un ERP.
- Seguir operando ante **cortes de internet** acotados.

**[OBSERVADO]** Referentes del segmento (Localshop, TUU liviano) priorizan simplicidad y onboarding en minutos frente a suites omnicanal.

## Usuarios objetivo

| Persona | Necesidad principal |
|---------|---------------------|
| Dueño de tienda | Visibilidad de ventas, márgenes, stock, usuarios |
| Cajero | Cobrar, escanear/buscar producto, emitir boleta |
| Supervisor | Ajustar inventario, promociones, revisar caja |
| Contador (secundario) | Exportación/libro ventas (fase posterior) |

## Objetivo del producto (MVP)

Construir un **POS segmento D**: mobile-first, catálogo colaborativo opcional, inventario básico, roles simples, boleta electrónica y modo offline acotado.

## Relación con Kora CRM (y complementos)

El POS debe **operar de forma autónoma**: venta, caja, inventario local y boleta (con adaptador propio) **sin** Kora ni ningún back-office en la nube.

**Kora es integración opcional** para **complementos** (CRM avanzado, sincronización centralizada, funciones que el núcleo no cubre). Que Kora también ofrezca DTE, inventario u otras áreas **no obliga** al POS a usarlos; ver `14-nucleo-y-complementos-kora.md`.

## Fuera de alcance (MVP)

- Contabilidad completa, remuneraciones, factoring (complemento Kora u otro, no núcleo).
- Integración obligatoria con Kora CRM.
- Integración nativa con agregadores de delivery.
- Omnicanal (tienda web propia, marketplaces).
- ERP multisucursal enterprise.
- Adquirencia propia (terminal propio como negocio); solo **integración** con medios de pago registrados.
- Catálogo colaborativo global en v1 (se deja como `[ESPECULATIVO]` fase 2).

## Alcance geográfico y regulatorio

- **Chile**: SII, boleta electrónica, contribuyentes primera categoría (definición detallada en RF/RNF).
- Moneda: CLP.

## Éxito medible (MVP)

1. Un negocio piloto puede **completar venta + boleta** en &lt; 30 s por ítem escaneado (conectado).
2. **Cierre de caja** cuadra medios de pago con ventas del turno.
3. **Ajuste de inventario** reflejado en siguiente venta.
4. Cobertura de pruebas de comportamiento en **API pública documentada** ≥ 80 % en módulos de venta e inventario (ver doc 09).

## Dependencias externas

| Dependencia | Uso |
|-------------|-----|
| SII (DTE) | Emisión boleta; ambiente certificación antes de producción |
| Certificado digital del contribuyente | Proporcionado por el cliente |
| Pasarela/terminal de pago | Fase posterior a MVP core (slice explícito) |