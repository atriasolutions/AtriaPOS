import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/session_provider.dart';
import 'ports/shift_repository.dart';

class EndSession {
  EndSession(this._sessions, this._shifts);

  final SessionProvider _sessions;
  final ShiftRepository _shifts;

  Future<void> call(StoreId storeId) async {
    requireActiveSession(_sessions);
    final open = await _shifts.findOpenByStore(storeId);
    if (open != null) {
      throw const ValidationFailure(
        'Cierre la caja antes de cambiar de usuario',
      );
    }
    _sessions.clear();
  }
}