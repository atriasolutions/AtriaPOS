# SLICE-28 — Índice unificado tienda piloto

Documentación operativa; sin tests automatizados de markdown.

## SC-028-01 — Índice maestro

```gherkin
Dado un operador que abrirá tienda piloto
Cuando consulta runbooks/tienda-piloto-indice.md
Entonces encuentra orden para CI local, integración opcional a main, demo DTE fake, piloto BLE, piloto SII y enlace a evidencia agregada
```

Verificación: `runbooks/tienda-piloto-indice.md`, enlaces desde `ble-piloto-indice.md`, `sii-piloto-indice.md`, `merge-mvp-hito.md`, `pr-body-mvp.md`.

## SC-028-02 — Evidencia agregada

```gherkin
Dado la ruta de tienda piloto en curso
Cuando se registra avance operativo
Entonces runbooks/tienda-piloto-evidencia.md define estados PREPARADO/PARCIAL/CERRADO y remite a evidencias BLE y SII
```

Verificación: `runbooks/tienda-piloto-evidencia.md`.