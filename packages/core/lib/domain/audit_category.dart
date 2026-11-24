import 'failures.dart';

enum AuditCategory {
  ventas('VENTAS'),
  inventario('INVENTARIO'),
  usuarios('USUARIOS'),
  pagos('PAGOS');

  const AuditCategory(this.apiValue);

  final String apiValue;

  static AuditCategory fromApi(String value) {
    final upper = value.trim().toUpperCase();
    for (final c in AuditCategory.values) {
      if (c.apiValue == upper) return c;
    }
    throw ValidationFailure('Categoría de auditoría no válida: $value');
  }

  static Set<AuditCategory> parseCsv(String? csv) {
    if (csv == null || csv.trim().isEmpty) {
      return AuditCategory.values.toSet();
    }
    final parts = csv.split(',');
    return parts.map((p) => fromApi(p)).toSet();
  }
}