import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'collaborator_planilla_auth.dart';
import 'ports/collaborator_repository.dart';
import 'ports/session_provider.dart';

class CreateCollaboratorInput {
  const CreateCollaboratorInput({
    required this.storeId,
    required this.sellerCode,
    required this.firstName,
    required this.lastName,
  });

  final StoreId storeId;
  final String sellerCode;
  final String firstName;
  final String lastName;
}

class CreateCollaborator {
  CreateCollaborator(this._repo, this._sessions);

  final CollaboratorRepository _repo;
  final SessionProvider _sessions;

  Future<Collaborator> call(CreateCollaboratorInput input) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.gestionarPlanilla,
    );
    final collaborator = Collaborator.create(
      storeId: input.storeId,
      sellerCode: input.sellerCode,
      firstName: input.firstName,
      lastName: input.lastName,
    );
    await assertActiveSellerCodeAvailable(
      _repo,
      input.storeId,
      collaborator.sellerCode,
    );
    await _repo.save(collaborator);
    return collaborator;
  }
}