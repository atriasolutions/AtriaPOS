# SLICE-124 — Cámara en APK release (ProGuard / R8)

Evidencia de piloto en dispositivo Android real (operador).

## SC-124-01 — APK release abre la cámara

```gherkin
Dado flutter build apk tras SLICE-124 e instalación en el celular
Y el POS companion HTTPS en ejecución
Cuando el usuario toca Leer QR del POS y concede la cámara
Entonces el visor muestra preview (no genericError ni pantalla negra con NPE)
```

## SC-124-02 — contrato ProGuard

Automatizado: `companion_android_proguard_test.dart`.