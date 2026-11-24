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

### RF-022 [S] Alerta stock bajo

Umbral por producto o global.

---

## Ventas (POS)

### RF-030 [M] Carro de venta

Agregar, cambiar cantidad, quitar ítem, ver total.

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