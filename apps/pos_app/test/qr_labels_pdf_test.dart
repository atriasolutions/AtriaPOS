import 'package:core/api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/export/qr_labels_pdf.dart';

void main() {
  test('SC-081-01 genera PDF no vacío', () async {
    final bytes = await buildQrLabelsPdfBytes([
      const ProductResponse(
        id: 'p1',
        name: 'Pan',
        salePriceClp: 500,
        stock: 3,
        qrPayload: 'atria://prod/p1',
      ),
    ]);
    expect(bytes, isNotEmpty);
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}