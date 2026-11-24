# SLICE-81 — Export PDF etiquetas QR

## SC-081-01

```gherkin
Dado productos con qrPayload
Cuando genera PDF de etiquetas
Entonces obtiene archivo PDF válido (DEC-051 grilla 3x5)
```

Verificación: `qr_labels_pdf_test.dart`.