# DEC — RF-001 alta de tienda (SLICE-12)

| Tema | Decisión |
|------|----------|
| Una tienda | MVP un registro por dispositivo; segundo bootstrap → CONFLICTO |
| Bootstrap | Sin sesión si `stores` vacío; crea tienda + `usr_dueno` + sesión |
| `storeId` | UUID v4 en instalaciones nuevas; tests usan seed `tienda_demo` |
| `tax_config` | JSON fijo `{"defaultTaxTreatment":"AFECTO"}` en v1 |
| Emisor SII | `SiiLiveDteGateway` resuelve emisor desde SQLite; dart-define solo legacy/tests |
| Migración v9 | Inserta `tienda_demo` si existían productos/usuarios demo sin fila `stores` |