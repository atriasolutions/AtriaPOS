import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Completa selección de vendedor en el diálogo de cobro abierto.
Future<void> enterCheckoutSellerCode(
  WidgetTester tester, {
  String sellerCode = 'V01',
}) async {
  final field = find.byKey(const Key('checkout_seller_code_field'));
  if (field.evaluate().isEmpty) return;
  await tester.enterText(field, sellerCode);
  await tester.pumpAndSettle();
}

/// Elige efectivo e ingresa el monto recibido para habilitar Cobrar.
Future<void> chooseCheckoutCash(WidgetTester tester, int amountClp) async {
  final pay = find.byKey(const Key('checkout_pay_efectivo'));
  await tester.ensureVisible(pay);
  await tester.tap(pay);
  await tester.pumpAndSettle();
  await tester.enterText(
    find.byKey(const Key('checkout_cash_received')),
    '$amountClp',
  );
  await tester.pumpAndSettle();
}