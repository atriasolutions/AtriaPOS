import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-070-03 cajero no ajusta inventario', () async {
    final products = InMemoryProductRepository();
    final movements = InMemoryStockMovementRepository();
    final supervisorSessions = InMemorySessionProvider.supervisor();
    final product = await CreateProduct(products, supervisorSessions)(
      const CreateProductInput(
        storeId: storeId,
        name: 'Pan',
        salePriceClp: 500,
        initialStock: 10,
      ),
    );

    final cajeroSessions = InMemorySessionProvider(
      initial: AuthSession(
        userId: 'usr_cajero',
        role: UserRole.cajero,
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
      ),
    );
    final service = InventoryService(
      productRepository: products,
      stockMovementRepository: movements,
      sessionProvider: cajeroSessions,
    );

    final result = await service.adjustStock(
      storeId,
      product.id,
      const AdjustStockRequest(delta: -1, reason: 'MERMA'),
    );
    expect(result, isA<ApiFailure<AdjustStockResponse>>());
    expect((result as ApiFailure<AdjustStockResponse>).statusCode, 403);
  });
}