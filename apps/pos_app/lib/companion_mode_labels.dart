import 'package:core/domain/domain.dart';

String companionModeCajaLabel(CompanionMode mode) {
  return switch (mode) {
    CompanionMode.vender => 'Vender',
    CompanionMode.receiptScan => 'Ingreso mercadería',
    CompanionMode.countScan => 'Conteo inventario',
  };
}