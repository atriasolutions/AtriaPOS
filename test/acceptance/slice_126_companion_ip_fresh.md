# SLICE-126 — IP fresca en el QR

## SC-126-01 (automatizado)

Dos tablas de interfaces distintas producen hosts distintos; `prepareCompanionQr` ignora `companionAdvertisedHost` cacheada si hay override en tests.

## SC-126-UI-01 (manual)

Tras cambiar adaptador de red, abrir QR de nuevo: la URL copiada coincide con `ipconfig` sin reiniciar la app del POS (cert puede requerir reinicio POS).