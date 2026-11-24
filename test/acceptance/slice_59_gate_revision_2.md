# SLICE-59 — Gate R2 (revisión 2)

## SC-059-01 — Plan revisión 2 publicado

```gherkin
Dado revisión 1 cerrada en acta 19
Cuando se lee docs/20-plan-revision-2-atria-pos.md
Entonces define plantilla Atria POS, fases R2-A y R2-B
Y lista slices SLICE-59 a SLICE-76
```

## SC-059-02 — Fuera de alcance R3

```gherkin
Dado el plan revisión 2
Cuando se lee la sección fuera de alcance y docs/20b-esbozo-revision-3.md
Entonces emisión SII productiva vía Kora queda en revisión 3
```

## SC-059-03 — Gate R2 checklist

```gherkin
Dado equipo listo para código R2
Cuando completan checklist §3 doc 20 (G2-01 a G2-07)
Entonces SLICE-59 queda CERRADO
Y está autorizado abrir feat/slice-60
```

Verificación: [`docs/20-plan-revision-2-atria-pos.md`](../../docs/20-plan-revision-2-atria-pos.md) §3.