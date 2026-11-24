# SLICE-79 — Stock de productos

## SC-079-UI-01

```gherkin
Dado cajero con sesión activa
Cuando abre Stock de productos desde PRODUCTOS o menú
Entonces ve lista con nombre, precio y stock
```

Verificación: `product_stock_list_ui_e2e_test.dart`, `list_store_products_test.dart`.