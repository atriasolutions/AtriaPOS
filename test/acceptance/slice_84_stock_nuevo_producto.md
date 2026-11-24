# SLICE-84 — Nuevo producto desde Stock

## SC-084-UI-01

```gherkin
Dado supervisor o dueño con plantilla Atria
Cuando abre Stock de productos
Entonces ve el botón Nuevo producto en la barra superior
```

## SC-084-UI-02

```gherkin
Dado cajero con permiso solo consultar stock
Cuando abre Stock de productos
Entonces no ve el botón Nuevo producto
```

## SC-084-UI-03

```gherkin
Dado usuario habilitado
Cuando pulsa Nuevo producto
Entonces navega a la pantalla de creación de producto
```

Verificación: `product_stock_list_ui_e2e_test.dart`, `canCreateProduct` en `pos_menu_ui.dart`.