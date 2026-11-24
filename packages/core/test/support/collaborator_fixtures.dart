import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';

/// Colaborador activo por defecto para tests de checkout (SC-084).
Future<void> seedDefaultSeller(
  CollaboratorRepository repo,
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