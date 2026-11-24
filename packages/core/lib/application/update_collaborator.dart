import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'collaborator_planilla_auth.dart';
import 'ports/collaborator_repository.dart';
import 'ports/session_provider.dart';

class UpdateCollaboratorInput {
  const UpdateCollaboratorInput({
    required this.storeId,
    required this.collaboratorId,
    this.sellerCode,
    this.firstName,
    this.lastName,
    this.active,
  });

  final StoreId storeId;
  final CollaboratorId collaboratorId;
  final String? sellerCode;
  final String? firstName;
  final String? lastName;
  final bool? active;
}

class UpdateCollaborator {
  UpdateCollaborator(this._repo, this._sessions);

  final CollaboratorRepository _repo;
  final SessionProvider _sessions;

  Future<Collaborator> call(UpdateCollaboratorInput input) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.gestionarPlanilla,
    );
    final current = await _repo.findById(input.storeId, input.collaboratorId);
    if (current == null) {
      throw NotFoundFailure(
        'Colaborador no encontrado',
        details: {'collaboratorId': input.collaboratorId},
      );
    }

    var sellerCode = current.sellerCode;
    if (input.sellerCode != null) {
      sellerCode = SellerCodePolicy.normalize(input.sellerCode!);
    }
    var firstName = current.firstName;
    if (input.firstName != null) {
      firstName = input.firstName!.trim();
      if (firstName.isEmpty) {
        throw const ValidationFailure('Ingrese el nombre');
      }
    }
    var lastName = current.lastName;
    if (input.lastName != null) {
      lastName = input.lastName!.trim();
      if (lastName.isEmpty) {
        throw const ValidationFailure('Ingrese el apellido');
      }
    }
    final active = input.active ?? current.active;

    final updated = current.withUpdates(
      sellerCode: sellerCode,
      firstName: firstName,
      lastName: lastName,
      active: active,
    );

    if (updated.active) {
      await assertActiveSellerCodeAvailable(
        _repo,
        input.storeId,
        updated.sellerCode,
        excludeId: updated.id,
      );
    }

    await _repo.save(updated);
    return updated;
  }
}