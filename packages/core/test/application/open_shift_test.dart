import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late InMemoryShiftRepository shifts;
  late OpenShift openShift;

  setUp(() {
    shifts = InMemoryShiftRepository();
    openShift = OpenShift(shifts);
  });

  test('SC-040-01 abre turno', () async {
    final shift = await openShift(storeId, 50000);
    expect(shift.openingCashClp, 50000);
    expect(shift.isOpen, isTrue);
  });

  test('SC-040-02 segundo open → CONFLICTO', () async {
    await openShift(storeId, 1000);
    expect(
      () => openShift(storeId, 2000),
      throwsA(isA<ConflictFailure>()),
    );
  });
}