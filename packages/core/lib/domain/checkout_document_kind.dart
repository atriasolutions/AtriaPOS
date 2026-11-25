import 'dte_document_type.dart';

enum CheckoutDocumentKind {
  boleta,
  factura;

  int get dteDocumentType => switch (this) {
        CheckoutDocumentKind.boleta => DteDocumentType.boleta,
        CheckoutDocumentKind.factura => DteDocumentType.factura,
      };

  String get apiValue => switch (this) {
        CheckoutDocumentKind.boleta => 'BOLETA',
        CheckoutDocumentKind.factura => 'FACTURA',
      };

  static CheckoutDocumentKind fromApi(String? raw) {
    final trimmed = raw?.trim().toUpperCase() ?? '';
    return switch (trimmed) {
      'FACTURA' => CheckoutDocumentKind.factura,
      '' || 'BOLETA' => CheckoutDocumentKind.boleta,
      _ => CheckoutDocumentKind.boleta,
    };
  }
}