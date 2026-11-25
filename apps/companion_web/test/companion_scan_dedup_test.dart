import 'package:companion_web/companion_scan_dedup.dart';
import 'package:test/test.dart';

void main() {
  test('SC-110-03 ignora el mismo código dentro de 400 ms', () {
    final dedup = CompanionScanDedup(
      window: const Duration(milliseconds: 400),
    );
    final t0 = DateTime(2026, 1, 1, 12, 0, 0);
    expect(dedup.shouldAccept('780123', t0), isTrue);
    expect(
      dedup.shouldAccept(
        '780123',
        t0.add(const Duration(milliseconds: 200)),
      ),
      isFalse,
    );
    expect(
      dedup.shouldAccept(
        '780123',
        t0.add(const Duration(milliseconds: 500)),
      ),
      isTrue,
    );
  });

  test('código distinto siempre se acepta', () {
    final dedup = CompanionScanDedup();
    final t0 = DateTime(2026, 1, 1);
    expect(dedup.shouldAccept('A', t0), isTrue);
    expect(dedup.shouldAccept('B', t0), isTrue);
  });
}