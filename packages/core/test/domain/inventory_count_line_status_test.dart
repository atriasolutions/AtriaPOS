import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  test('SC-152-01 sin cantidad es sin contar', () {
    final r = resolveInventoryCountLineStatus(10, null);
    expect(r.status, InventoryCountLineStatus.sinContar);
    expect(r.delta, isNull);
  });

  test('SC-152-02 coincide con sistema es contado', () {
    final r = resolveInventoryCountLineStatus(10, 10);
    expect(r.status, InventoryCountLineStatus.contado);
    expect(r.delta, 0);
  });

  test('SC-152-03 sobrante es diferencias positivas', () {
    final r = resolveInventoryCountLineStatus(10, 12);
    expect(r.status, InventoryCountLineStatus.diferencias);
    expect(r.delta, 2);
  });

  test('SC-152-04 faltante es diferencias negativas', () {
    final r = resolveInventoryCountLineStatus(10, 7);
    expect(r.status, InventoryCountLineStatus.diferencias);
    expect(r.delta, -3);
  });
}