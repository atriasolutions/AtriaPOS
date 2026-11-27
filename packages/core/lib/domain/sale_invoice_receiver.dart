import 'failures.dart';
import 'rut_chile.dart';

class SaleInvoiceReceiver {
  const SaleInvoiceReceiver({
    required this.rut,
    required this.businessName,
    required this.giro,
    required this.email,
    required this.address,
    required this.city,
    required this.commune,
    required this.phone,
  });

  /// RUT en formato visual Chile (con puntos).
  final String rut;
  final String businessName;
  final String giro;
  final String email;
  final String address;
  final String city;
  final String commune;
  final String phone;

  static SaleInvoiceReceiver validate({
    required String rutRaw,
    required String businessNameRaw,
    required String giroRaw,
    required String emailRaw,
    required String addressRaw,
    required String cityRaw,
    required String communeRaw,
    required String phoneRaw,
  }) {
    if (!RutChile.isValid(rutRaw)) {
      throw const ValidationFailure('RUT del receptor no válido');
    }
    return SaleInvoiceReceiver(
      rut: RutChile.formatDisplay(rutRaw),
      businessName: _required(businessNameRaw, 'razón social'),
      giro: _required(giroRaw, 'giro'),
      email: _email(emailRaw),
      address: _required(addressRaw, 'dirección'),
      city: _required(cityRaw, 'ciudad'),
      commune: _required(communeRaw, 'comuna'),
      phone: _required(phoneRaw, 'teléfono'),
    );
  }

  static String _required(String raw, String label) {
    final value = raw.trim();
    if (value.isEmpty) {
      throw ValidationFailure('Ingrese $label del receptor');
    }
    return value;
  }

  static String _email(String raw) {
    final value = raw.trim();
    final at = value.indexOf('@');
    if (at <= 0 || !value.substring(at + 1).contains('.')) {
      throw const ValidationFailure('Correo electrónico no válido');
    }
    return value;
  }
}
