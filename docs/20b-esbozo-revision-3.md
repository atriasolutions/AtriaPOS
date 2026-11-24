# 20b — Esbozo revisión 3 (SII / Kora)

**Estado:** stub — sin slices ni fechas  
**Prerrequisito:** revisión 2 cerrada — **cumplido** (acta 19 §12, SLICE-77, 2026-11-24)  
**No forma parte de la revisión 2** ([`20-plan-revision-2-atria-pos.md`](20-plan-revision-2-atria-pos.md)).

---

## Objetivo

Integrar la **emisión de boletas hacia el SII** como canal **Kora**, complemento del núcleo POS, en una tercera revisión del programa.

## Relación con documentación vigente

- [`14-nucleo-y-complementos-kora.md`](14-nucleo-y-complementos-kora.md): el POS revisión 1 opera con `DteGateway` propio y Kora como complemento opcional.
- Revisión 3 requerirá **DEC** (doc 16+) sobre:
  - frontera Kora vs adaptador local;
  - coexistencia con cola DTE y piloto revisión 1;
  - datos operativos del turno en POS vs emisor en Kora.

## Fuera de este esbozo

- Orden de slices, contratos API y RF definitivos.
- Compromiso de fechas o ambientes SII.

## Próximo paso (cuando corresponda)

Redactar `docs/21-plan-revision-3.md` (o ampliar este archivo) tras cierre documental de revisión 2.