# 09 — Estrategia TDD

## Ciclo vertical (obligatorio)

```text
1. Leer RF + escenario en doc 07 o en test/acceptance/*.md
2. Escribir test de comportamiento (falla)
3. Implementación mínima en packages/core
4. Refactor manteniendo verde
5. Actualizar doc si el contrato cambió (mismo PR)
```

**Prohibido en MVP:** generar todos los tests de una vertical sin implementar; no “horizontal specs dump”.

## Pirámide de pruebas

| Nivel | Qué prueba | Herramienta |
|-------|------------|-------------|
| Dominio | Invariantes INV-0x, cálculo totales | `test`, puro Dart |
| Casos de uso | Orquestación con fakes | `test` + mockitos/manual fakes |
| Contrato API | Request/response doc 07 | `integration_test` o harness HTTP |
| UI | Smoke críticos (1 flujo venta) | `integration_test` Flutter, pocos |

## Ubicación de archivos (convención futura)

```text
packages/core/test/
  domain/
    sale_totals_test.dart
  application/
    confirm_sale_test.dart
test/acceptance/
  slice_03_confirm_sale.md    # escenarios legibles + referencia
```

## Formato escenario (Gherkin en Markdown)

Archivo: `test/acceptance/slice_03_confirm_sale.md`

```gherkin
Feature: Confirmar venta con boleta
  Background:
    Given tienda "Minimarket La Esquina" con turno abierto
    And producto "Pan" precio 500 stock 10

  Scenario: Venta efectivo exacta
  When el cajero agrega 2 unidades de "Pan"
  And confirma pago efectivo 1000
  Then la venta queda CONFIRMADA
  And el stock de "Pan" es 8
  And el DTE queda EMITIDA
```

El test Dart referencia el `Scenario` por nombre o ID `SC-030-01`.

## Fakes obligatorios

| Puerto | Fake |
|--------|------|
| `DteGateway` | `FakeDteGateway` (modos: ok, timeout, rechazo) |
| `Clock` | `FixedClock` |
| `IdGenerator` | secuencia predecible |

## CI (cuando exista repo)

```bash
dart test packages/core
flutter test apps/pos_app
flutter test apps/pos_app/test/sale_flow_e2e_test.dart
```

Umbral: fallar build si cobertura `packages/core` &lt; 80 % (activar tras SLICE-4).

## Definition of Done — test

- Escenario RF [M] mapeado a test automatizado.
- Sin `skip` permanente.
- Nombres de test en español o inglés consistente (elegir uno en Gate 1; propuesta: **español** en descriptions, código en inglés).

## Anti-patrones

- Test que solo verifica mocks sin assert de resultado observable.
- UI test frágil por cada pantalla antes de estabilizar core.
- Depender de red/SII en tests unitarios.