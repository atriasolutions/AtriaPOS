import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-032-02 API cajero no anula venta', () async {
    final sales = InMemorySaleRepository();
    final shifts = InMemoryShiftRepository();
    await shifts.save(
      Shift(
        id: 'sh1',
        storeId: storeId,
        openingCashClp: 0,
        openedAt: DateTime.utc(2026, 1, 1),
        status: ShiftStatus.abierto,
      ),
    );
    await sales.save(
      Sale(
        id: 'sale_1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 100),
        ],
        totalClp: 100,
        changeClp: 0,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    );
    final service = SaleService(
      saleRepository: sales,
      shiftRepository: shifts,
      sessionProvider: InMemorySessionProvider.cajero(),
    );
    final result = await service.voidSale(storeId, 'sale_1');
    expect(result, isA<ApiFailure<VoidSaleResponse>>());
    final failure = result as ApiFailure<VoidSaleResponse>;
    expect(failure.statusCode, 403);
    expect(failure.error.code, 'PERMISO_DENEGADO');
  });
}