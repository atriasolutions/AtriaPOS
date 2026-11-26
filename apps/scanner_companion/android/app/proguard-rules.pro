# SLICE-124: mobile_scanner + ML Kit en APK release (R8).
# El consumer del plugin usa com.google.mlkit.* (un nivel); R8 podía eliminar subpaquetes
# y provocar NPE al abrir la cámara (genericError en Xiaomi/Android 13).

-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_barcode.** { *; }
-keep class com.google.android.gms.internal.mlkit_** { *; }
-keep class com.google.android.libraries.barhopper.** { *; }
-keep class dev.steenbakker.mobile_scanner.** { *; }
-keep class androidx.camera.** { *; }