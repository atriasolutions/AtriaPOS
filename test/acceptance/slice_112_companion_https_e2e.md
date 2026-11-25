# SLICE-112 — E2E companion tres flujos (HTTPS tanda)

## Escenarios automatizados

### SC-112-01 Vender
Dado producto con código de barras y pair `VENDER`  
Cuando el celular envía `scan` por WS  
Entonces el POS puede resolver el producto vía `searchProducts` (como pantalla Vender)

### SC-112-02 Ingreso
Dado sesión `receiptScan` abierta y pair `RECEIPT_SCAN`  
Cuando llega escaneo por LAN  
Entonces `recordScan` agrega línea a la sesión

### SC-112-03 Conteo
Dado turno abierto, sesión `countScan` y pair `COUNT_SCAN`  
Cuando llega escaneo por LAN  
Entonces `recordScan` registra el producto en la sesión

### SC-112-04 Enlace corto
Dado QR generado con `prepareCompanionQr`  
Entonces `GET /c/{code}` responde 302 hacia `/companion/?…`

### SC-112-05 Regresión
SC-101–103 y SC-111 siguen verdes en `companion_lan_e2e_test.dart`.

## Piloto manual (SC-112-06)

Ver tabla HTTPS en [`runbooks/companion-lan-install-ca.md`](../../runbooks/companion-lan-install-ca.md) o guía [`runbooks/companion-lan-manual-pilot.md`](../../runbooks/companion-lan-manual-pilot.md).

## Automatización

`apps/pos_app/test/companion_lan_flow_e2e_test.dart`, helpers en `test/support/companion_lan_flow_helpers.dart`.