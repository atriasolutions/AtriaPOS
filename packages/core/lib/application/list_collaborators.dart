import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/collaborator_repository.dart';
import 'ports/session_provider.dart';

class ListCollaborators {
  ListCollaborators(this._repo, this._sessions);

  final CollaboratorRepository _repo;
  final SessionProvider _sessions;

  Future<List<Collaborator>> call(StoreId storeId) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.gestionarPlanilla,
    );
    return _repo.listByStore(storeId);
  }
}