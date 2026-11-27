/// Formato legible Chile para UI (usa instante UTC de negocio).
String formatChileDateTime(DateTime utcInstant) {
  final parts = _utcParts(utcInstant);
  return '${parts.date} ${parts.time}';
}

String formatChileDate(DateTime utcInstant) {
  return _utcParts(utcInstant).date;
}

String formatChileTime(DateTime utcInstant) {
  return _utcParts(utcInstant).time;
}

String formatChileTimeHm(DateTime utcInstant) {
  return _utcParts(utcInstant).timeHm;
}

/// Fecha compacta para franja superior (`27-Nov-26`).
String formatChileStripDate(DateTime utcInstant) {
  final local = utcInstant.toUtc();
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final yy = (local.year % 100).toString().padLeft(2, '0');
  return '${local.day}-${months[local.month - 1]}-$yy';
}

/// Hora 12 h para franja superior (`1:52 PM`).
String formatChileStripTime(DateTime utcInstant) {
  final local = utcInstant.toUtc();
  final period = local.hour >= 12 ? 'PM' : 'AM';
  var hour12 = local.hour % 12;
  if (hour12 == 0) hour12 = 12;
  final min = local.minute.toString().padLeft(2, '0');
  return '$hour12:$min $period';
}

({String date, String time, String timeHm}) _utcParts(DateTime utcInstant) {
  final local = utcInstant.toUtc();
  // Presentación en UTC con etiqueta; la app puede envolver con timezone package.
  final y = local.year.toString().padLeft(4, '0');
  final m = local.month.toString().padLeft(2, '0');
  final d = local.day.toString().padLeft(2, '0');
  final h = local.hour.toString().padLeft(2, '0');
  final min = local.minute.toString().padLeft(2, '0');
  final s = local.second.toString().padLeft(2, '0');
  return (
    date: '$d/$m/$y',
    time: '$h:$min:$s',
    timeHm: '$h:$min',
  );
}