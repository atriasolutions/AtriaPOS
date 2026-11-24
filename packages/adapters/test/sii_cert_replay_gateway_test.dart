import 'package:adapters/adapters.dart';
import 'package:core/atria_pos_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-080-01 replay con cert válido → EMITIDA', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    final sales = DriftSaleRepository(db);
    final certs = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Test',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 30)),
        status: CertificateStatus.valido,
      );
    final gateway = SiiCertReplayDteGateway(
      sales: sales,
      certificates: certs,
      scenario: SiiReplayScenario.success,
      fixtureOverrides: const {'success': 'success'},
    );
    final sale = await _seedSale(sales, storeId);
    final result = await gateway.emit(
      DteEmitRequest.fromSale(sale),
    );
    expect(result.status, DteStatus.emitida);
    expect(result.folio, 88001);
  });

  test('SC-080-02 certificado vencido → PENDIENTE_DTE', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    final sales = DriftSaleRepository(db);
    final certs = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Old',
        validFrom: DateTime.utc(2020),
        validTo: DateTime.utc(2021),
        status: CertificateStatus.vencido,
      );
    final queue = InMemoryDteQueueRepository();
    final gateway = SiiCertReplayDteGateway(
      sales: sales,
      certificates: certs,
    );
    final sale = await _seedSale(sales, storeId);
    final updated = await emitSaleDte(sale, gateway, queue);
    expect(updated.dteStatus, DteStatus.pendienteDte);
    expect(await queue.listPending(storeId), hasLength(1));
  });
}

Future<Sale> _seedSale(DriftSaleRepository sales, StoreId storeId) async {
  final sale = Sale(
    id: 'sale_sii_01',
    storeId: storeId,
    shiftId: 'shift_1',
    cartId: 'cart_1',
    lines: [
      SaleLine(
        productId: 'p1',
        productName: 'Pan',
        quantity: 2,
        unitPriceClp: 500,
      ),
    ],
    payments: [
      Payment.create(method: PaymentMethod.efectivo, amountClp: 1000),
    ],
    totalClp: 1000,
    changeClp: 0,
    createdAt: DateTime.utc(2026, 1, 1),
  );
  await sales.save(sale);
  return sale;
}