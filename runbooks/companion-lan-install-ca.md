# Companion LAN — instalar certificado en Android

## Cuándo

Primera conexión HTTPS al POS (`https://{ip}:8765/c/...`).

## Pasos

1. En el celular, abra `https://{ip}:8765/companion/instalar-certificado`.
2. Descargue `atria-ca.pem`.
3. Android: **Ajustes → Seguridad → Más seguridad → Instalar certificado → CA**.
4. Vuelva a escanear el QR del POS.

## Notas

- El PEM publicado coincide con el certificado del servidor en esta versión MVP.
- Si la IP cambia (USB ↔ Wi‑Fi), escanee el QR nuevo.
- Puerto por defecto: **8765**.

## Desconectar celular (SLICE-111)

Si cambia el operador del mostrador o el celular deja de usarse, en el POS use **Desconectar celular** en el diálogo del QR o cierre la sesión antes de un nuevo emparejamiento.

## Triple flujo HTTPS (SLICE-112, piloto manual)

Tras CA instalada y `flutter build web` en `companion_web`:

| Flujo | QR modo | Resultado esperado |
|-------|---------|-------------------|
| Vender | VENDER | Producto en pantalla venta |
| Ingreso | RECEIPT_SCAN | Línea en sesión de ingreso |
| Conteo | COUNT_SCAN | Línea en sesión de conteo |

Detalle: [`companion-lan-manual-pilot.md`](companion-lan-manual-pilot.md) (usar HTTPS en laboratorio).

| Fecha | A/B/C | Resultado |
|-------|-------|-----------|
| — | — | **PREPARADO** |

## Cámara (SLICE-110, piloto manual)

Requiere `flutter build web` en `apps/companion_web` antes de servir la PWA.

| Fecha | Dispositivo | HTTPS + CA | Cámara escanea | Notas |
|-------|-------------|------------|----------------|-------|
| — | — | — | **PREPARADO** | Si FALLA, operar con ingreso manual (DEC-061) |