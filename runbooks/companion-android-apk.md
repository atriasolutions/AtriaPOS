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

## Uso (UX v2 — SLICE-139…143)

1. En el POS, abra **Companion WiFi** (QR) en Vender, Ingreso o Conteo.
2. En la app: toque inferior **Vincular con la caja** → cámara para el QR del POS (primera vez: permiso de cámara).
3. Tras vincular: barra **En la caja** + modo (ej. Vender). **Más opciones** ya no aparece.
4. Escanee productos; pulse **Escanear** (DEC-065). Manual: **Escribir código**.
5. Ícono salir (arriba derecha) desvincula.
6. Desconectado: **Más opciones** (debajo del botón) → pegar enlace `https://{ip}:8765/c/{codigo}`.

Brief: [`docs/companion-android-ux-v2.md`](../docs/companion-android-ux-v2.md).

**No usar** el flujo BLE «Pareo escáner» en `main.dart` para companion LAN (legacy en código).

## Piloto v2 (SC-143-UI-01)

| Paso | OK |
|------|-----|
| Botón vincular al pulgar | ☐ |
| QR → «En la caja» sin confundir con escaneo local | ☐ |
| Producto llega al POS | ☐ |
| Salir vuelve a vincular | ☐ |
| Fecha / commit / foto fuera repo | ☐ |

## Smoke

| Paso | Esperado |
|------|----------|
| Conectar con enlace vigente | Modo visible |
| Escanear un producto en Vender | El POS lo recibe |
| Enlace viejo | «Enlace no válido o expirado» |
