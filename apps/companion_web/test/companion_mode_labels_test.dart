import 'package:companion_web/companion_mode_labels.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-108-01 etiquetas de modo en español caja', () {
    expect(
      companionModeCajaLabel(CompanionMode.vender),
      'Vender',
    );
    expect(
      companionModeCajaLabel(CompanionMode.receiptScan),
      'Ingreso mercadería',
    );
    expect(
      companionModeCajaLabel(CompanionMode.countScan),
      'Conteo inventario',
    );
  });
}