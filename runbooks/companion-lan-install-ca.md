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