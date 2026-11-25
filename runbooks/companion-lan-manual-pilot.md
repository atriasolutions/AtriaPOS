# Piloto manual — Companion LAN (Bloque B)

Guía paso a paso para probar **companion WiFi** en tienda o laboratorio. Sin secretos en repo.

**Relacionado:** RF-098 · acceptance `slice_99_pos_qr.md` … `slice_103_*` · spike cámara [`companion-web-camera-http-spike.md`](companion-web-camera-http-spike.md).

---

## 0. Qué vas a validar

| # | Flujo | Modo QR | Resultado esperado en POS |
|---|--------|---------|---------------------------|
| A | Vender | `VENDER` | Código agrega/busca producto en pantalla venta |
| B | Ingreso stock | `RECEIPT_SCAN` | Código suma línea en sesión de escaneo (tras iniciar sesión) |
| C | Conteo inventario | `COUNT_SCAN` | Igual en conteo por escaneo |
| D | Emparejamiento | — | Solo **un** celular activo; el segundo revoca al primero |
| E | Spike cámara (opcional) | — | Runbook 95b |

---

## 1. Prerrequisitos

### Red y equipos

- PC caja con **Windows** y POS compilado (`apps/pos_app`).
- Celular Android conectado al PC por **WiFi misma red** **o** **USB tethering** (compartir internet móvil → PC).
- Anotar **IPv4 del PC** en ese enlace (no uses la IP 4G del teléfono):
  - `ipconfig` → buscar adaptador **Remote NDIS** / **USB** / **Ethernet** activo → Dirección IPv4.
  - USB típico Android→PC: `192.168.42.x` o `192.168.43.x` en el **PC**.

#### Solo USB (PC sin Wi‑Fi)

1. En el teléfono: **compartir internet / USB tethering** activo, cable conectado.
2. En el PC: `ipconfig` → IP del adaptador tether (ej. `192.168.42.129`).
3. Arrancar POS con esa IP fija:
   `--dart-define=COMPANION_LAN_HOST=192.168.42.129`
4. En el **mismo teléfono**, Brave: probar primero `http://{ESA-IP}:8765/health` (debe responder JSON).
5. Si el QR no abre: **copiar la URL completa** del diálogo del POS (no confiar solo en el escáner).
6. Firewall Windows → regla TCP **8765** en perfil **Privada** (el tether suele ser red privada).

### Datos demo (desarrollo)

| Ítem | Valor |
|------|--------|
| Tienda | `tienda_demo` (seed habitual) |
| PIN demo | `2468` (documentado en `PosComposition.demoPin`) |
| Usuario supervisor | `usr_supervisor` |
| Usuario dueño | `usr_dueno` |

### Piloto smartphone (recomendado)

Un solo script prepara la PWA y te indica cómo levantar el POS:

```powershell
cd <raíz del repo>
.\scripts\prepare-companion-pwa.ps1
```

Luego ejecuta el comando que imprime el script (incluye `COMPANION_WEB_ROOT` y puerto **8765**).

- El QR usa **IPv4 LAN auto** (`NetworkInterface`). Forzar IP: `--dart-define=COMPANION_LAN_HOST=192.168.0.25`
- El servidor escucha en **0.0.0.0** (accesible desde el celular en la misma WiFi).

**Alternativa rápida (misma PC, sin celular):** `flutter run -d chrome` en `companion_web` y usa la URL del QR (sección 4).

### Firewall Windows

- Permitir entrada **TCP** en el puerto que use el servidor (el QR lleva el puerto real; el POS usa puerto **dinámico** si `port: 0` en composition — léelo siempre del QR o de `GET /health`).
- Regla sugerida: “Atria Companion LAN” → puerto mostrado en el QR → redes **privadas** only.

---

## 2. Arranque del POS

1. Desde repo:
   ```powershell
   cd apps\pos_app
   flutter pub get
   flutter run -d windows
   ```
2. Si es primera vez: bootstrap tienda demo (flujo normal de la app) o asegúrate de tener tienda activa.
3. **Iniciar sesión** (supervisor o dueño) y **abrir turno** para flujo Vender.
4. Abre **Companion WiFi** (botón con QR) en pantalla Vender — debe aparecer código alfanumérico y URL.

**Smoke red (opcional en PC caja):**

```powershell
# Sustituye PUERTO e IP según el QR
curl http://127.0.0.1:PUERTO/health
```

Respuesta esperada: `{"ok":true,"service":"companion-lan"}`.

---

## 3. Abrir el companion en el celular

1. En el POS: **Companion WiFi** → muestra QR y URL completa.
2. En Android: escanea QR con la cámara o Chrome.
3. La URL debe verse así:
   `http://{IP}:{puerto}/companion/?storeId=…&mode=VENDER&pairingCode=XXXXXX`
4. Si usas build web copiado al servidor: carga la PWA.
5. Pulsa **Emparejar** — estado “Conectado”.

Si emparejar falla: revisa IP en QR, firewall, que el código no haya expirado (**30 min**, doc 23b) ni hayas generado otro QR (invalida el anterior).

---

## 4. Alternativa — companion en Chrome del mismo PC

1. Genera QR en Vender y copia la URL.
2. Si la PWA no está en `/companion/`, ejecuta:
   ```powershell
   cd apps\companion_web
   flutter run -d chrome --web-launch-url="URL_COPIADA_DEL_QR"
   ```
   (Ajusta la URL para que el **host:puerto** apunten al POS, no al puerto de dev de Flutter.)
3. **Emparejar** → campo **Código de barras** → **Enviar escaneo**.

---

## 5. Casos de prueba

### A — Vender (RF-098 / SLICE-101)

| Paso | Acción | Esperado |
|------|--------|----------|
| A1 | Turno abierto, carrito visible | — |
| A2 | QR modo **VENDER**, emparejar celular | Companion conectado |
| A3 | Escanea producto con stock (o escribe payload/ código en campo manual) | Búsqueda en POS; producto al carrito o mensaje “sin productos” |
| A4 | Repite mismo código en &lt; 400 ms | Segundo bip ignorado (antirrebote) |
| A5 | Empareja otro dispositivo con **nuevo** QR | Primer token deja de enviar scans |

**Producto de prueba:** crea uno con código de barras conocido o usa payload QR de producto demo desde la app.

### B — Ingreso por escaneo (SLICE-102)

| Paso | Acción | Esperado |
|------|--------|----------|
| B1 | Menú → **Ingreso existencias** → modo **Por escaneo** | — |
| B2 | **QR companion WiFi** → `mode=RECEIPT_SCAN` | — |
| B3 | Completa guía y lote → **Iniciar sesión de escaneo** | Sesión activa |
| B4 | Empareja companion (mismo modo) y escanea productos | Líneas en lista de escaneo |
| B5 | **Confirmar ingreso** | Stock actualizado |

### C — Conteo por escaneo (SLICE-103)

| Paso | Acción | Esperado |
|------|--------|----------|
| C1 | **Cierre inventario** → modo **Por escaneo** | Preview cargado |
| C2 | **QR companion WiFi** → `mode=COUNT_SCAN` | — |
| C3 | **Iniciar conteo por escaneo** | Sesión activa |
| C4 | Escaneos desde companion | Líneas de conteo |
| C5 | **Confirmar conteo** | Cierre registrado según reglas de inventario |

### D — Modo incorrecto (negativo)

| Paso | Acción | Esperado |
|------|--------|----------|
| D1 | QR generado para **VENDER** | — |
| D2 | Emparejar con body `mode` distinto (solo si pruebas API) | Error validación |
| D3 | En app: abre QR de ingreso pero dejaste oferta de vender | Emparejamiento falla al pair |

### E — Spike cámara HTTP (SLICE-95b)

Seguir [`companion-web-camera-http-spike.md`](companion-web-camera-http-spike.md) con URL **LAN real** (`http://192.168.x.x:puerto/...`), no `localhost`.

Registrar en la tabla del spike: **PASA** / **FALLA** + modelo Android + versión Chrome.

---

## 6. Evidencia a guardar (piloto)

- Captura QR + IP:puerto visibles.
- Captura companion “Conectado”.
- Captura POS tras escaneo (carrito, líneas ingreso o conteo).
- Para 95b: fila completada en tabla del runbook spike.
- Anotar: fecha, versión commit (`git rev-parse --short HEAD`), puerto usado.

Plantilla de registro:

```text
Fecha:
Commit:
PC IP:
Puerto LAN:
Flujos probados: A / B / C / D / E
Resultado global: OK / con observaciones
Observaciones:
```

---

## 7. Problemas frecuentes

| Síntoma | Causa probable | Qué hacer |
|---------|----------------|-----------|
| Celular no abre URL | QR con `127.0.0.1` | Cambiar `companionAdvertisedHost` a IP LAN y regenerar QR |
| `Emparejamiento falló` | Código expirado o revocado | Cerrar diálogo QR y abrir de nuevo |
| Scan no llega al POS | Token viejo tras nuevo QR | Re-emparejar en companion |
| No hay UI en `/companion/` | Sin `build web` en servidor | Build + `staticRoot` o usar alternativa sección 4 |
| Cámara no inicia | HTTP no seguro en Android | Spike 95b; planear TLS si falla |
| Firewall bloquea | Puerta cerrada en Windows | Regla entrada TCP puerto del QR |
| Modo ingreso sin sesión | Falta “Iniciar sesión escaneo” | B3 / C3 antes de escanear |

---

## 8. Cierre del piloto

- [ ] A, B y C ejecutados al menos una vez en LAN real con celular **o** documentado uso solo PC (sección 4).
- [ ] Spike 95b ejecutado o marcado “pendiente hardware”.
- [ ] Evidencia archivada fuera del repo (carpeta piloto tienda).
- [ ] Si FAIL cámara HTTP: abrir ítem TLS / DEC amend según doc 23b.