# 04 — Requisitos funcionales

Prioridad: **M** = Must (MVP), **S** = Should (1.5), **C** = Could (2).

## Identidad y configuración

### RF-001 [M] Alta de tienda

**Descripción:** Registrar tienda con RUT, razón social, giro y configuración de impuestos.

**Criterios de aceptación**

- Dado que no existe tienda, cuando el dueño completa datos válidos y confirma, entonces se persiste la tienda y queda sesión activa.
- Dado RUT inválido, cuando intenta guardar, entonces rechaza con mensaje claro.

### RF-002 [M] Usuarios y roles

Roles MVP: `DUENO`, `SUPERVISOR`, `CAJERO`.

| Acción | Dueño | Supervisor | Cajero |
|--------|:-----:|:----------:|:------:|
| Vender | ✓ | ✓ | ✓ |
| Ajustar inventario | ✓ | ✓ | — |
| Cerrar caja | ✓ | ✓ | — |
| Configurar precios/costo | ✓ | ✓ | — |
| Gestionar usuarios | ✓ | — | — |

### RF-081 [M] Permisos heredados Atria POS (SLICE-61)

- Dado rol cajero, cuando evalúa permisos, entonces solo `vender` y `consultarStock` (más herencia futura por plantilla).
- Dado jefe de turno (`supervisor`), cuando evalúa, entonces incluye permisos de cajero y operación de turno (reportes, auditoría, inventario, caja).
- Dado jefe de tienda (`dueno`), cuando evalúa, entonces incluye jefe de turno y `gestionarUsuarios`.
- Dado acción protegida, cuando el rol no tiene permiso en matriz, entonces `PERMISO_DENEGADO`.

### RF-080 [M] Perfil usuario (revisión 2, SLICE-60)

Campos: `id` (UUID), nombre, apellido, RUT persona, `username`, PIN.

- Dado dueño autenticado, cuando crea usuario con datos válidos, entonces persiste UUID y `username` único en la tienda.
- Dado login, cuando ingresa `username` y PIN correctos, entonces abre sesión con rol correspondiente.
- Dado `username` o PIN con letra ñ, cuando intenta crear o autenticar, entonces rechaza con `VALIDACION`.
- Dado RUT persona inválido, cuando crea usuario, entonces rechaza con `VALIDACION`.
- Dado nombre/apellido con tildes o ñ, cuando crea usuario, entonces acepta (solo credenciales sin ñ).

Listado y edición (SLICE-70):

- Dado dueño autenticado, cuando lista usuarios de la tienda, entonces ve perfiles con username, nombre, RUT y rol (sin PIN).
- Dado dueño, cuando edita nombre, apellido, RUT o rol de cajero/supervisor, entonces persiste y actualiza `displayName`.
- Dado dueño, cuando envía PIN nuevo opcional válido, entonces el usuario inicia sesión con ese PIN; si omite PIN, el anterior sigue vigente.
- Dado usuario con rol `DUENO`, cuando edita, entonces no puede cambiarse el rol; `username` permanece inmutable.
- Dado supervisor o cajero, cuando lista o edita usuarios, entonces `PERMISO_DENEGADO`.

### RF-003 [S] Certificado SII

Carga de certificado y validación de vigencia (sin almacenar clave en texto plano en logs).

---

## Catálogo

### RF-010 [M] Crear producto en tienda

Campos mínimos: nombre, precio venta, opcional barcode, opcional costo.

- Dado supervisor autenticado, cuando crea producto con precio &gt; 0, entonces queda disponible en búsqueda y POS.
- Dado barcode duplicado en tienda, cuando intenta crear, entonces advierte o rechaza según política configurada (`PERMITIR_DUPLICADO_BARCODE`).

### RF-011 [M] Buscar producto

Por texto, barcode manual o escaneo (cliente).

- Dado texto parcial del nombre, cuando busca en POS, entonces lista coincidencias ordenadas por relevancia en &lt; 500 ms (local).

### RF-012 [S] Stock inicial al crear producto

Opcional cantidad inicial.

### RF-013 [C] Importar desde base colaborativa

Fuera MVP; dejar interfaz `ProductCatalogPort` vacía.

---

## Inventario

### RF-020 [M] Consultar stock

Por producto: cantidad disponible.

### RF-021 [M] Ajuste manual y merma

- Dado supervisor, cuando registra merma con motivo, entonces decrementa stock y audita movimiento.
- Dado cantidad resultante &lt; 0 y política estricta, entonces rechaza.

### RF-085 [M] Ingreso existencias con guía y lote (SLICE-65)

Complementa inventario barrio: recepción trazable sin crear SKU en el acto.

- Dado supervisor (o rol con `ajustarInventario`), cuando registra ingreso sobre **producto existente** con cantidad &gt; 0, **guía** y **lote** válidos, entonces incrementa stock y persiste movimiento `RECEPCION` con referencias.
- Dado producto inexistente, entonces `NO_ENCONTRADO`.
- Dado guía, lote o cantidad inválidos, entonces `VALIDACION`.
- Dado `POST .../adjustments` con motivo `RECEPCION`, entonces `VALIDACION` (usar ingreso dedicado API-004).
- El ingreso aparece en auditoría del día (RF-070) con guía y lote en el resumen.

### RF-022 [S] Alerta stock bajo

Umbral por producto o global.

Materializado en consulta reporte **RF-087** (SLICE-67); alertas push fuera de MVP.

---

## Ventas (POS)

### RF-030 [M] Carro de venta

Agregar, cambiar cantidad, quitar ítem, ver total.

### RF-082 [M] Carrito editable por roles de venta (SLICE-62)

Complementa RF-030 en revisión 2: operaciones de carro (API-002) requieren **sesión activa** y **`Permission.vender`**.

- Dado cajero, supervisor o dueño autenticado (plantilla Atria POS, RF-081), cuando crea carro, agrega, cambia cantidad o elimina línea, entonces la operación se permite.
- Dado sin sesión, cuando invoca endpoints de carro, entonces rechaza con credencial inválida (401).
- Dado cantidad de línea ≤ 0 al actualizar, entonces `VALIDACION`.

UI (SLICE-71): en pantalla **Vender**, cada línea del carro muestra cantidad con botones **− / +** y acción **quitar**; actualiza total vía API-002; roles con `vender` (cajero, supervisor, dueño).

### RF-083 [M] Planilla colaboradores (SLICE-63)

Colaboradores de mostrador con **código vendedor**, separados de usuarios POS (DEC-049).

- Dado jefe de tienda autenticado, cuando crea, lista, actualiza o desactiva colaborador con datos válidos, entonces persiste en planilla de la tienda.
- Dado código vendedor duplicado entre activos, cuando guarda, entonces `CONFLICTO`.
- Dado supervisor o cajero, cuando intenta administrar planilla, entonces `PERMISO_DENEGADO`.
- Dado código con ñ o fuera de formato (2–8, A–Z, 0–9), entonces `VALIDACION`.

### RF-084 [M] Código vendedor en venta (SLICE-64)

- Dado checkout Atria POS, cuando confirma venta, entonces debe indicar `sellerCode` de colaborador **activo** en planilla.
- Dado `sellerCode` ausente, inválido o sin colaborador activo, entonces `VALIDACION` (400).
- Dado rol con `Permission.vender`, cuando lista colaboradores activos para venta, entonces solo códigos vigentes (API-011 `active`).
- La venta persiste `sellerCode` para trazabilidad; sin motor de comisiones en R2.

UI (SLICE-72): antes de confirmar cobro, el operador elige vendedor desde colaboradores activos o ingresa código; sin código válido no puede confirmar.

### RF-031 [M] Confirmar venta

- Descuenta stock (si aplica).
- Registra pagos (MVP: efectivo y “otro”; integración terminal en slice posterior).
- Dispara emisión DTE.

### RF-032 [M] Anular venta del día

Solo rol supervisor/dueño, dentro de ventana configurable (ej. mismo turno).

### RF-033 [S] Promoción pack / descuento línea

### RF-034 [S] Fiado

Cliente con saldo; no bloquea MVP si se pospone a SLICE-7.

---

## Caja

### RF-040 [M] Apertura de turno

Saldo inicial en efectivo.

### RF-041 [M] Cierre de caja

Reporte: ventas por medio, efectivo esperado vs contado, diferencia.

### RF-042 [S] Retiros / ingresos de efectivo en turno

---

## Fiscal (DTE)

### RF-050 [M] Emitir boleta electrónica

Al confirmar venta conectada y certificado válido.

### RF-051 [M] Cola offline / fallo SII

Venta queda `PENDIENTE_DTE`; reintento manual o automático al reconectar.

### RF-052 [S] Envío boleta por correo/WhatsApp

Canal configurable.

---

## Reportes

### RF-060 [M] Ventas del día

Total, ticket promedio, cantidad transacciones.

### RF-061 [S] Margen por producto

Requiere costo cargado.

### RF-062 [C] Export CSV para contador

---

## Trazabilidad

### RF-070 [M] Auditoría mínima

Quién confirmó venta, quién ajustó stock, timestamp (sin PII innecesaria).

Ampliado por **RF-086** (rango y categorías).

### RF-086 [M] Auditoría por rango y categoría (SLICE-66)

Supervisor o dueño consultan eventos entre fechas locales (máx. **31 días** inclusive), con filtro opcional por categoría: **VENTAS** (`CONFIRMA_VENTA`, `ANULA_VENTA`), **INVENTARIO** (ajustes excepto motivo venta), **USUARIOS** (altas usuario POS), **PAGOS** (stub vacío hasta integración Transbank). Compatibilidad: query `date=` de un día (RF-070). Sin export ni UI ampliada en este slice (SLICE-74).

### RF-087 [M] Stock insights (SLICE-67)

Supervisor o dueño consultan en un reporte: productos con **stock bajo** (stock ≤ umbral efectivo: `lowStockThreshold` por producto o default **5** unidades) y **ranking de más vendidos** en los últimos **30 días** calendario (unidades, ventas anuladas excluidas). Query `asOf` opcional; `limit` del ranking (default 10, máx. 50). Sin UI en este slice (SLICE-73).

### RF-089 [M] Modelo plantilla Atria POS (SLICE-69)

Cada tienda tiene `posTemplateId`; en R2-A solo **ATRIA_POS** es asignable en bootstrap. La plantilla define **features** del producto (qué módulos existen); el **rol** sigue restringiendo operación (DEC-048). Consulta `GET .../pos-template` devuelve `templateId`, `displayName` y `features[]`. Checkout exige código vendedor solo si la plantilla incluye `sellerCodeCheckout` (Atria: sí). ID desconocido en persistencia → fallback **ATRIA_POS**. Menú dinámico en UI: SLICE-75.

### RF-088 [M] Cierre inventario (SLICE-68)

Con **turno abierto**, supervisor o dueño:

- Consultan **vista previa** con stock sistema y unidades vendidas en el turno por SKU.
- Envían **recuento manual** por producto; el sistema calcula `variance = contado - sistema`.
- Si `variance ≠ 0`, aplica movimiento **CORRECCION** y deja stock al contado; si es cero, solo registra la línea.
- Persiste cabecera y líneas de cierre para trazabilidad. Sin turno abierto → error alineado a SC-040. Sin UI (SLICE-74).

---

## Clasificación núcleo vs complemento (Gate 2)

Completar en plan [`15`](15-plan-definicion-pre-implementacion.md) F0-3.

| ID | Ámbito | Núcleo |
|----|--------|:------:|
| RF-001…003 | Identidad / SII config | ✅ núcleo (cert); sync Kora = complemento |
| RF-010…013 | Catálogo | ✅ excepto RF-013 colaborativo = complemento |
| RF-020…022 | Inventario | ✅ |
| RF-030…034 | Ventas | ✅ excepto RF-033–034 opcionales post-MVP |
| RF-040…042 | Caja | ✅ |
| RF-050…052 | Fiscal POS | ✅ núcleo propio; Kora DTE = complemento no obligatorio |
| RF-060…062 | Reportes | ✅ mínimo; export profundo = complemento |
| RF-070 | Auditoría | ✅ |