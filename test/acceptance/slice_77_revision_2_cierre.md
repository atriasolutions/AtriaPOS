# SLICE-77 — Cierre revisión 2 (integración `main`)

Tras SLICE-76; piloto BLE formal sigue SLICE-50.

## SC-077-01 — CI local verde

```gherkin
Dado cierre revisión 2 solicitado
Cuando se ejecuta scripts/ci-local.ps1
Entonces todas las suites pasan en el commit de cierre
```

Verificación: `scripts/ci-local.ps1` en commit SLICE-77.

## SC-077-02 — Slices 59–76 en origin/main

```gherkin
Dado push directo a main en atriasolutions/AtriaPOS
Cuando se consulta origin/main
Entonces incluye commits feat(slice-59) hasta feat(slice-76)
Y el commit de cierre feat(slice-77)
```

Verificación: `git fetch origin && git log origin/main -20 --oneline`.

## SC-077-03 — Acta revisión 2

```gherkin
Dado revisión 2 cerrada documentalmente
Cuando se lee docs/19-revision-progreso-20251120.md §12
Entonces DoD revisión 2 está marcado
Y SLICE-50 permanece ABIERTO
```

Verificación: [`docs/19-revision-progreso-20251120.md`](../../docs/19-revision-progreso-20251120.md).

## SC-077-04 — Plan R2 cerrado

```gherkin
Cuando se lee docs/20-plan-revision-2-atria-pos.md
Entonces el estado indica revisión 2 cerrada
Y la cola SLICE-59 a SLICE-76 está completa
```

Verificación: [`docs/20-plan-revision-2-atria-pos.md`](../../docs/20-plan-revision-2-atria-pos.md).