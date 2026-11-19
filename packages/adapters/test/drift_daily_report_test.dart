import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';
  late AppDatabase db;
  late DriftSaleRepository sales;
  late GetDailySalesReport getReport;

  final day = DateTime(2026, 3, 18);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    sales = DriftSaleRepository(db);
    getReport = GetDailySalesReport(
      sales,
      InMemorySessionProvider.supervisor(),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('SC-060-02 drift reporte diario excluye anuladas', () async {
    await sales.save(
      Sale(
        id: 's1',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c1',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 1000),
        ],
        totalClp: 1000,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 18, 10),
      ),
    );
    await sales.save(
      Sale(
        id: 's2',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c2',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 1500),
        ],
        totalClp: 1500,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 18, 14),
      ),
    );
    await sales.save(
      Sale(
        id: 's3',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c3',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 500),
        ],
        totalClp: 500,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 18, 16),
        status: SaleStatus.anulada,
      ),
    );
    await sales.save(
      Sale(
        id: 'other_day',
        storeId: storeId,
        shiftId: 'sh1',
        cartId: 'c4',
        lines: const [],
        payments: [
          Payment.create(method: PaymentMethod.efectivo, amountClp: 9999),
        ],
        totalClp: 9999,
        changeClp: 0,
        createdAt: DateTime(2026, 3, 19, 9),
      ),
    );

    final report = await getReport(storeId, calendarDayLocal: day);
    expect(report.salesTotalClp, 2500);
    expect(report.transactionCount, 2);
    expect(report.averageTicketClp, 1250);
  });
}