import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/collaborator_repository.dart';
import 'ports/session_provider.dart';

class DeactivateCollaborator {
  DeactivateCollaborator(this._repo, this._sessions);

  final CollaboratorRepository _repo;
  final SessionProvider _sessions;

  Future<Collaborator> call(StoreId storeId, CollaboratorId id) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.gestionarPlanilla,
    );
    final current = await _repo.findById(storeId, id);
    if (current == null) {
      throw NotFoundFailure(
        'Colaborador no encontrado',
        details: {'collaboratorId': id},
      );
    }
    if (!current.active) {
      return current;
    }
    final updated = current.withUpdates(active: false);
    await _repo.save(updated);
    return updated;
  }
}