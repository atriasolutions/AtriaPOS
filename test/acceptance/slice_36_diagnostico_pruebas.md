# SLICE-36 — Diagnóstico de pruebas (pre–próximo slice)

## SC-DIAG-01 — Baseline suites

```gherkin
Dado el repositorio en rama feat/slice-0-scaffold
Cuando se ejecuta la paridad ci-local (core, adapters, pos_app)
Entonces las tres suites quedan en verde con conteos documentados
```

Verificación: `runbooks/test-diagnostico-evidence.md`.

## SC-DIAG-02 — Cobertura core

```gherkin
Dado packages/core con dart test --coverage
Cuando se genera lcov sobre lib/
Entonces el porcentaje de líneas queda registrado y comparado con RNF-030 (≥80 %)
```

Verificación: `docs/18-diagnostico-pruebas.md` §3.

## SC-DIAG-03 — Recomendación próximo slice

```gherkin
Dado el informe de diagnóstico completado
Cuando se revisan pendientes manuales SC-080-03, SC-030-01 y SC-011-BLE-01
Entonces el informe declara una recomendación primaria y una alternativa con prerequisitos de operador
```

Verificación: `docs/18-diagnostico-pruebas.md` §4.