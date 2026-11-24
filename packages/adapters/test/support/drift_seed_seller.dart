import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';

Future<void> driftSeedDefaultSeller(
  DriftCollaboratorRepository repo,
  StoreId storeId, {
  String sellerCode = 'V01',
}) async {
  final code = SellerCodePolicy.normalize(sellerCode);
  final existing = await repo.findActiveBySellerCode(storeId, code);
  if (existing != null) return;
  await repo.save(
    Collaborator.create(
      storeId: storeId,
      sellerCode: code,
      firstName: 'Colab',
      lastName: 'Venta',
    ),
  );
}