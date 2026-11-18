# 14 — Núcleo POS vs complementos (Kora opcional)

**Decisión de producto y arquitectura** — vigente desde Gate 1 ampliado (2026-11-18).

## Regla madre

1. El **núcleo del POS** resuelve, **por sí solo**, las necesidades básicas de un punto de venta segmento D (docs `00`, `04` [M]).
2. **Kora CRM** (u otro back-office) puede ofrecer **complementos**: funciones que el POS **no** incluye en su núcleo, o que el cliente elige centralizar en la nube.
3. El solapamiento de funcionalidades entre POS y Kora **no es un defecto**: lo no-núcleo en el POS puede delegarse o **reforzarse** vía complemento, pero **nunca** ser obligatorio para operar la caja.

## Núcleo (obligatorio sin Kora)

Debe funcionar **100 % offline-capable** en lo operativo de mostrador (venta, stock local, cola DTE según doc `08`), con emisión DTE vía adaptador propio del POS (`DteGateway`), no vía Kora.

| Área | Capacidades núcleo (referencia RF [M]) |
|------|----------------------------------------|
| Identidad local | Tienda, usuarios, roles (RF-002) |
| Catálogo tienda | Crear, buscar, barcode (RF-010, RF-011) |
| Inventario | Stock, ajuste/merma (RF-020, RF-021) |
| Ventas | Carro, confirmar, anular día (RF-030–032) |
| Caja | Turno, cierre (RF-040, RF-041) |
| Fiscal POS | Boleta, cola offline SII (RF-050, RF-051) |
| Reportes mínimos | Ventas del día (RF-060) |
| Auditoría básica | RF-070 |

**Criterio de aceptación arquitectónico:** todos los tests de comportamiento del núcleo pasan con adaptadores **NoOp** o **Fake** en puertos de complemento (`ComplementGateway`, `CrmSyncGateway`, etc.).

## Complementos (opcionales con Kora u otros)

Funciones **fuera del núcleo** o **ampliadas** cuando el cliente contrata integración:

| Complemento | Ejemplos | POS sin Kora |
|-------------|----------|--------------|
| CRM avanzado | Oportunidades, pipelines, actividades comerciales | No disponible o stub local mínimo (cliente nombre/RUT en venta) |
| Marketing / WhatsApp | Bandejas, plantillas | Fuera de POS |
| Back-office financiero | Contabilidad, F29, remuneraciones | Export manual futuro (RF [C]) |
| Compras / RCV profundo | Recepción masiva proveedores | Ajuste manual inventario |
| E-commerce / marketplaces | Shopify, ML | Fuera de MVP |
| DTE alternativo vía Kora | Emisión centralizada en Kora | POS usa **propio** `DteGateway` |
| Pagos bancarios online | Conciliación bancaria en Kora | Terminal integrado vía `PaymentTerminalPort` propio |

**[OBSERVADO]** Kora declara módulos amplios (CRM, DTE, inventario, API, webhooks). En esta estrategia, esos módulos son **complementos contratables**, no dependencias del runtime del POS.

## Modelo mental

```mermaid
flowchart TB
  subgraph nucleo [Nucleo POS - siempre presente]
    V[Venta caja]
    I[Inventario local]
    D[DTE adaptador propio]
    C[Cierre caja]
  end
  subgraph comp [Complementos - opcional]
    K[Kora CRM]
    O[Otros integradores]
  end
  V --> I
  V --> D
  V --> C
  nucleo -.->|eventos opcionales sync| comp
  comp -.x-|x sin Kora| nucleo
```

La línea punteada es **unidireccional de publicación** (POS → complemento) o **sincronización bajo demanda**; **nunca** “Kora → obligatorio para vender”.

## Reglas de implementación

| # | Regla |
|---|--------|
| R-K1 | Ningún caso de uso [M] del núcleo importa SDK ni cliente HTTP de Kora. |
| R-K2 | Integración Kora solo en `packages/adapters/kora_*` (o similar), detrás de `ComplementPort` / `CrmSyncPort`. |
| R-K3 | Configuración: `kora.enabled = false` por defecto; sin API key = sin llamadas. |
| R-K4 | Si complemento falla (red, 4xx/5xx), la venta en mostrador **sigue**; cola de sync reintenta. |
| R-K5 | Duplicar dominio “completo” en Kora está permitido en complemento; el **dato operativo del turno** vive en POS hasta sync exitoso. |
| R-K6 | Tests del núcleo (SLICE 1–5) **no** requieren Kora. Tests de complemento: suite aparte, tag `complement`. |

## Puertos (extensión doc 06)

| Puerto | Núcleo | Implementación sin Kora | Con Kora (complemento) |
|--------|--------|-------------------------|-------------------------|
| `DteGateway` | **Sí** | `Fake` / `Sii*` / API DTE propia | No sustituye núcleo salvo política explícita del cliente |
| `PaymentTerminalPort` | Slice pagos | Transbank / Getnet / … | Opcional doble registro en Kora |
| `CrmSyncPort` | No | `NoOpCrmSync` | `KoraCrmSyncAdapter` |
| `CatalogComplementPort` | No | `NoOp` | Publicar/recibir catálogo Kora |
| `ReportingExportPort` | No [C] | CSV local | Reportes Kora |

## Fricciones que **sí** hay que diseñar (sin hacer Kora obligatorio)

| Tema | Mitigación |
|------|------------|
| Dos copias de cliente/producto | IDs locales + `external_ref` al sincronizar; conflicto resuelto en complemento, no en caja |
| Dos emisores DTE posibles | Por defecto: **solo núcleo emite** en POS; Kora complemento **no** emite por la misma venta salvo modo enterprise configurado |
| Función “complemento” mal clasificada en núcleo | Gate de revisión: todo RF nuevo etiqueta `nucleo` \| `complemento` |

## Relación con slices

| Slice | Kora |
|-------|------|
| SLICE-0 … SLICE-8 (MVP núcleo) | No |
| SLICE-C1 (futuro) | Integración complemento CRM — solo tras núcleo estable |

## Confirmación

- **Solapamiento con Kora:** aceptado; lo no-núcleo = complemento.
- **Dependencia de Kora para POS básico:** **prohibida** (R-K1, R-K3).