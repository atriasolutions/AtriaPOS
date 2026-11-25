# Companion Android — APK de piloto (SLICE-121)

App Flutter en `apps/scanner_companion`. Cámara nativa. No instala la CA en el teléfono.

## Build

```powershell
cd apps\scanner_companion
flutter pub get
flutter build apk
```

El APK queda en `build\app\outputs\flutter-apk\app-release.apk`. Cópielo al celular e instálelo (orígenes desconocidos).

## Uso

1. En el POS, abra el QR de Vender, Ingreso o Conteo y copie el enlace `https://{ip}:8765/c/{codigo}`.
2. En la app: pegue ese enlace y pulse **Conectar**. Debe decir **Conectado · Vender** (o el modo del QR).
3. **Escanear productos**. El código llega al POS.
4. Si cambia la IP, copie el enlace nuevo. No hay que instalar certificados.

## Smoke

| Paso | Esperado |
|------|----------|
| Conectar con enlace vigente | Modo visible |
| Escanear un producto en Vender | El POS lo recibe |
| Enlace viejo | «Enlace no válido o expirado» |
