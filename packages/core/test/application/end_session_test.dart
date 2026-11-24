import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-082-01 termina sesión sin turno abierto', () async {
    final sessions = InMemorySessionProvider.dueno();
    final shifts = InMemoryShiftRepository();
    final endSession = EndSession(sessions, shifts);
    await endSession(storeId);
    expect(sessions.current, isNull);
  });

  test('SC-082-02 con turno abierto rechaza', () async {
    final sessions = InMemorySessionProvider.dueno();
    final shifts = InMemoryShiftRepository();
    final open = OpenShift(shifts);
    await open(storeId, 10_000);
    final endSession = EndSession(sessions, shifts);
    expect(
      () => endSession(storeId),
      throwsA(isA<ValidationFailure>()),
    );
  });
}