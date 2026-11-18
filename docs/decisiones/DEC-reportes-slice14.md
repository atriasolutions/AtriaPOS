# DEC — RF-060 reportes (SLICE-14)

| Tema | Decisión |
|------|----------|
| Ventana | Día calendario hora local del dispositivo (00:00–24:00); `date` opcional en API (default hoy) |
| Ventas incluidas | `CONFIRMADA` únicamente; excluir `ANULADA` (`saleCountsForShiftTotals`) |
| Ticket promedio | `totalClp ~/ count` si `count > 0`, si no `0` |
| Permiso | Supervisor y dueño (`Permission.anularVenta`); sin nuevo permiso en v1 |
| Alcance | Métricas agregadas; sin desglose por medio de pago |