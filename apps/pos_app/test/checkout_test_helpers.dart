import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Completa selección de vendedor en el diálogo de cobro abierto.
Future<void> enterCheckoutSellerCode(
  WidgetTester tester, {
  String sellerCode = 'V01',
}) async {
  await tester.enterText(
    find.byKey(const Key('checkout_seller_code_field')),
    sellerCode,
  );
  await tester.pumpAndSettle();
}