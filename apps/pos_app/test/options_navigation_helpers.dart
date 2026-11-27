import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Abre pantalla Opciones desde la venta (botón en barra superior).
Future<void> openSaleOptionsScreen(WidgetTester tester) async {
  final menu = find.byKey(const Key('operation_menu_button'));
  if (menu.evaluate().isEmpty) return;
  await tester.tap(menu);
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('options_screen')), findsOneWidget);
}

Finder get _optionsScrollable => find.descendant(
      of: find.byKey(const Key('options_screen')),
      matching: find.byType(Scrollable),
    );

/// Toca un ítem en Opciones (hace scroll si queda fuera de pantalla).
Future<void> tapOptionsMenuItem(WidgetTester tester, Key itemKey) async {
  await openSaleOptionsScreen(tester);
  final item = find.byKey(itemKey);
  final scrollable = _optionsScrollable;
  if (scrollable.evaluate().isNotEmpty) {
    await tester.scrollUntilVisible(
      item,
      120,
      scrollable: scrollable.first,
    );
  }
  await tester.pumpAndSettle();
  await tester.tap(item);
  await tester.pumpAndSettle();
}