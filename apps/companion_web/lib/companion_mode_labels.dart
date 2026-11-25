import 'package:core/domain/domain.dart';

/// Etiquetas de modo para caja (DEC-061, SLICE-108).
String companionModeCajaLabel(CompanionMode mode) {
  return switch (mode) {
    CompanionMode.vender => 'Vender',
    CompanionMode.receiptScan => 'Ingreso mercadería',
    CompanionMode.countScan => 'Conteo inventario',
  };
}