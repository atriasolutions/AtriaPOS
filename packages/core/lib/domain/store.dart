import 'rut_chile.dart';
import 'store_id.dart';
import 'tax_config.dart';
import 'failures.dart';

class Store {
  const Store({
    required this.id,
    required this.rut,
    required this.legalName,
    required this.businessLine,
    required this.taxConfig,
    required this.createdAt,
  });

  final StoreId id;
  /// Formato display `12.345.678-5`
  final String rut;
  final String legalName;
  final String businessLine;
  final TaxConfig taxConfig;
  final DateTime createdAt;

  factory Store.create({
    required StoreId id,
    required String rutRaw,
    required String legalName,
    required String businessLine,
    TaxConfig? taxConfig,
    DateTime? createdAt,
  }) {
    final name = legalName.trim();
    final giro = businessLine.trim();
    if (name.isEmpty) {
      throw const ValidationFailure('Ingrese la razón social');
    }
    if (giro.isEmpty) {
      throw const ValidationFailure('Ingrese el giro');
    }
    if (!RutChile.isValid(rutRaw)) {
      throw const ValidationFailure('RUT inválido');
    }
    return Store(
      id: id,
      rut: RutChile.formatDisplay(rutRaw),
      legalName: name,
      businessLine: giro,
      taxConfig: taxConfig ?? const TaxConfig(),
      createdAt: createdAt ?? DateTime.now().toUtc(),
    );
  }
}