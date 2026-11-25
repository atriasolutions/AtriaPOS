# SLICE-115 — Smoke companion LAN (PC)

## Script

`scripts/verify-companion-lan.ps1` — requiere POS en ejecución con HTTPS puerto **8765**.

## Escenarios automatizados (PC)

### SC-115-01
Dado el servidor companion activo  
Cuando `GET https://{host}:8765/health`  
Entonces el JSON contiene `"ok":true`.

### SC-115-02
Cuando `GET https://{host}:8765/companion/`  
Entonces el cuerpo es HTML de la PWA (no `No encontrado`).

### SC-115-03
Cuando `GET https://{host}:8765/companion/instalar-certificado`  
Entonces el HTML enlaza `atria-ca.pem`.

## Checklist manual celular (tras smoke PC verde)

| # | Paso | OK |
|---|------|-----|
| M1 | Instalar CA desde URL del diálogo QR | |
| M2 | Escanear QR → carga PWA | |
| M3 | Un escaneo llega a Vender | |
| M4 | (Opcional) Ingreso y conteo | |

Evidencia: acta [`slice_115_cierre_piloto_https.md`](slice_115_cierre_piloto_https.md).