import '../domain/domain.dart';
import 'ports/collaborator_repository.dart';

Future<void> assertActiveSellerCodeAvailable(
  CollaboratorRepository repo,
  StoreId storeId,
  String sellerCode, {
  CollaboratorId? excludeId,
}) async {
  final code = SellerCodePolicy.normalize(sellerCode);
  final existing = await repo.findActiveBySellerCode(storeId, code);
  if (existing != null && existing.id != excludeId) {
    throw ConflictFailure(
      'Ya existe un colaborador activo con ese código',
      details: {'sellerCode': code},
    );
  }
}