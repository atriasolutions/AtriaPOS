class TaxConfig {
  const TaxConfig({this.defaultTaxTreatment = 'AFECTO'});

  final String defaultTaxTreatment;

  Map<String, dynamic> toJson() => {
        'defaultTaxTreatment': defaultTaxTreatment,
      };

  factory TaxConfig.fromJson(Map<String, dynamic> json) {
    return TaxConfig(
      defaultTaxTreatment:
          json['defaultTaxTreatment'] as String? ?? 'AFECTO',
    );
  }

  static TaxConfig parse(String jsonString) {
    // Minimal JSON sin dart:convert dependency en dominio puro — caller puede pasar map.
    if (jsonString.contains('EXENTO')) {
      return const TaxConfig(defaultTaxTreatment: 'EXENTO');
    }
    return const TaxConfig();
  }

  String toJsonString() =>
      '{"defaultTaxTreatment":"$defaultTaxTreatment"}';
}