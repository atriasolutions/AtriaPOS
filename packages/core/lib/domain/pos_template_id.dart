import 'failures.dart';

enum PosTemplateId {
  atriaPos('ATRIA_POS'),
  /// Solo tests; no asignable en bootstrap productivo.
  barrioMinTest('BARRIO_MIN_TEST'),
  ;

  const PosTemplateId(this.apiValue);

  final String apiValue;

  static PosTemplateId fromApi(String value) {
    final upper = value.trim().toUpperCase();
    for (final id in PosTemplateId.values) {
      if (id.apiValue == upper) return id;
    }
    throw ValidationFailure('Plantilla POS no válida: $value');
  }

  /// Desconocido → Atria (RF-089).
  static PosTemplateId normalize(String? raw) {
    if (raw == null || raw.trim().isEmpty) return PosTemplateId.atriaPos;
    try {
      return fromApi(raw);
    } on ValidationFailure {
      return PosTemplateId.atriaPos;
    }
  }

  static bool isBootstrapAllowed(PosTemplateId id) =>
      id == PosTemplateId.atriaPos;
}