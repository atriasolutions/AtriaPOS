/// Formato legible Chile para UI (usa instante UTC de negocio).
String formatChileDateTime(DateTime utcInstant) {
  final local = utcInstant.toUtc();
  // Presentación en UTC con etiqueta; la app puede envolver con timezone package.
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  final h = local.hour.toString().padLeft(2, '0');
  final min = local.minute.toString().padLeft(2, '0');
  final s = local.second.toString().padLeft(2, '0');
  return '$d/$m/$y $h:$min:$s';
}