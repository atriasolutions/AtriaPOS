# Companion Android — APK de piloto (SLICE-121, SLICE-124)

App Flutter en `apps/scanner_companion`. Cámara nativa. No instala la CA en el teléfono.

## Build

```powershell
cd apps\scanner_companion
flutter pub get
flutter build apk
```

El APK queda en `build\app\outputs\flutter-apk\app-release.apk`. Cópielo al celular e instálelo (orígenes desconocidos).

**SLICE-124:** Tras cambios en `android/app/proguard-rules.pro`, reconstruya e **reinstale** el APK. R8 en release necesita esas reglas para que `mobile_scanner`/ML Kit no fallen con `genericError` (NPE en Logcat). Si la cámara falla solo en release y no en `flutter run`, revise las reglas antes de desactivar minify.

## Uso

1. En el POS, abra el QR de Vender, Ingreso o Conteo.
2. En la app: **Leer QR del POS**. La primera vez Android pide la cámara: acéptela. Si la negó, use **Abrir ajustes de la app**. También puede pegar el enlace `https://{ip}:8765/c/{codigo}`.
3. **Escanear productos**. El código llega al POS.
4. Si cambia la IP, copie el enlace nuevo. No hay que instalar certificados.

## Smoke

| Paso | Esperado |
|------|----------|
| Conectar con enlace vigente | Modo visible |
| Escanear un producto en Vender | El POS lo recibe |
| Enlace viejo | «Enlace no válido o expirado» |
