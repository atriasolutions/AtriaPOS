import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app/widgets/inventory_status_chip.dart';

void main() {
  testWidgets('SC-156-01 chip con etiqueta accesible', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: InventoryStatusChip(
            status: InventoryCountLineStatus.diferencias,
            delta: -2,
          ),
        ),
      ),
    );

    expect(find.text('Diferencias'), findsOneWidget);
    final semantics = tester.getSemantics(find.byType(InventoryStatusChip));
    expect(semantics.label, 'Faltante: Diferencias, diferencia -2');
  });
}