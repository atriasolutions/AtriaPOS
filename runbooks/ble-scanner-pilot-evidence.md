# Evidencia piloto SC-011-BLE-01

Completar en POS Windows + companion Android (no commitear capturas con datos sensibles).

Índice operativo: [`ble-piloto-indice.md`](ble-piloto-indice.md).

## Estado del documento

| Estado | Significado |
|--------|-------------|
| PREPARADO | Runbooks leídos; apps instaladas; piloto no ejecutado |
| CERRADO | Pareo OK, scan agrega producto al carro, evidencia archivada |

Estado actual: **PREPARADO** _(operador actualiza a CERRADO al terminar)_

## Pre-vuelo

| Ítem | Hecho |
|------|-------|
| Bluetooth activo en PC y teléfono | ☐ |
| Companion instalado en Android | ☐ |
| Producto de prueba con QR en catálogo | ☐ |
| Turno abierto y pantalla **Vender** | ☐ |
| Revisado [`ble-scanner-pairing.md`](ble-scanner-pairing.md) | ☐ |

## Evidencia pareo y escaneo

| Campo | Valor |
|-------|-------|
| Fecha piloto | _(completar)_ |
| Operador | _(completar)_ |
| Modelo POS (Windows) | _(completar)_ |
| Modelo teléfono Android | _(completar)_ |
| Código pareo 4 dígitos | _(completar)_ |
| Estado **Conectado** en POS | ☐ Sí |
| Scan QR agrega producto correcto al carro | ☐ Sí |
| Capturas POS + companion | ☐ Adjuntar fuera del repo |

## Notas

- Registrar mensajes de error BT o timeouts si el carro no recibe el payload.
- Tras piloto exitoso (estado **CERRADO**), actualizar matriz en [`docs/12b-matriz-verificacion-automatizacion.md`](../docs/12b-matriz-verificacion-automatizacion.md) en comentario del operador (manual).