import 'failures.dart';
import 'rut_chile.dart';

class SaleInvoiceReceiver {
  const SaleInvoiceReceiver({
    required this.rut,
    required this.businessName,
  });

  /// RUT en formato visual Chile (con puntos).
  final String rut;
  final String businessName;

  static SaleInvoiceReceiver validate({
    required String rutRaw,
    required String businessNameRaw,
  }) {
    if (!RutChile.isValid(rutRaw)) {
      throw const ValidationFailure('RUT del receptor no válido');
    }
    final name = businessNameRaw.trim();
    if (name.isEmpty) {
      throw const ValidationFailure('Ingrese razón social del receptor');
    }
    return SaleInvoiceReceiver(
      rut: RutChile.formatDisplay(rutRaw),
      businessName: name,
    );
  }
}