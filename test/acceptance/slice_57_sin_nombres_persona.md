# SLICE-57 — Sin nombres de persona en repo

## SC-057-01 — Gate automatizado

```gherkin
Dado scripts/deny-person-names.txt y check-no-person-names.ps1
Cuando se ejecuta scripts/ci-local.ps1
Entonces el paso check-no-person-names termina sin hallazgos
```

Verificación: `powershell -File scripts/check-no-person-names.ps1`; [`scripts/ci-local.ps1`](../../scripts/ci-local.ps1).

## SC-057-02 — Política DEC-045

```gherkin
Dado SLICE-57 cerrado
Cuando se lee docs/decisiones/DEC-045-sin-nombres-persona.md
Entonces documenta roles permitidos y evidencia sin nombres en git
```

## SC-057-03 — Evidencia piloto

```gherkin
Dado runbooks/tienda-piloto-evidencia.md
Cuando se lee el campo Operador
Entonces no contiene nombres propios de la denylist
```

Verificación: [`runbooks/tienda-piloto-evidencia.md`](../../runbooks/tienda-piloto-evidencia.md).