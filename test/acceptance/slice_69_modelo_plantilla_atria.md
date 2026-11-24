# SLICE-69 — Modelo plantilla Atria POS (RF-089)

## SC-089-01 — Bootstrap ATRIA_POS

```gherkin
Cuando creo tienda
Entonces posTemplateId ATRIA_POS
```

## SC-089-02 — API features

```gherkin
Cuando consulto pos-template
Entonces lista features Atria R2
```

## SC-089-03 — Menú rol

```gherkin
Cajero sin permiso userManagement aunque feature activa
```

## SC-089-04 — Feature apagada

```gherkin
Plantilla stub sin feature
Entonces ítem menú oculto
```

## SC-089-05 — Seller code

```gherkin
Atria exige sellerCode en checkout
```

## SC-089-06 — Drift

```gherkin
Persiste pos_template_id
```

## SC-089-07 — Fallback

```gherkin
Template desconocido → Atria
```

## SC-089-08 — Sin enterprise

```gherkin
Solo ATRIA_POS asignable en bootstrap
```

Tests: `pos_template_registry_test`, `get_pos_template_test`, `pos_template_api_test`, `drift_store_pos_template_test`.