# Índice — piloto certificación SII (SC-080-03)

Ruta tienda piloto (maestro): [`tienda-piloto-indice.md`](tienda-piloto-indice.md).

Guía operativa para Fase B en ambiente **certificación** (no producción). No incluir secretos ni capturas con datos sensibles en el repositorio.

## Orden recomendado

1. **Gate 0 — autorización cliente**  
   Completar [`docs/gate0-slice8b-piloto.md`](../docs/gate0-slice8b-piloto.md) antes de `SII_GATEWAY=live`.

2. **Artefactos en el dispositivo** (nunca en git)  
   Certificado `.pfx` + clave, CAF tipo 39 (`SII_CAF_PATH`), RUT emisor habilitado en portal certificación.

3. **Variables y arranque**  
   Seguir Fase B en [`sii-cert.md`](sii-cert.md) (`SII_GATEWAY=live`, `SII_AMBIENTE=cert`, etc.).

4. **Verificación en app**  
   Menú Operación → Certificado SII: estado **Válido** (`API-010`). Turno abierto → venta de prueba → diálogo **Venta registrada** con `dteStatus` **EMITIDA**, folio; pulsar **Copiar sale_id** y pegar en evidencia.

5. **Evidencia SC-080-03**  
   Registrar en [`sii-cert-pilot-evidence.md`](sii-cert-pilot-evidence.md) (folio, `sale_id`, captura portal fuera del repo).

6. **Rollback**  
   Volver a `SII_GATEWAY=fake` para demos; ver sección Rollback en [`sii-cert.md`](sii-cert.md).

## Recordatorios

- Claves solo vía `dart-define` local, no en chat ni commits.
- Si el SII rechaza: `RECHAZADA_SII` o cola `PENDIENTE_DTE` según caso — anotar en evidencia.
- Completar evidencia no sustituye revisión legal/fiscal del cliente.