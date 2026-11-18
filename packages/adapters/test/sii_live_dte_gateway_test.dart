import 'package:adapters/adapters.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  const storeId = 't1';

  test('SC-080-04 transport timeout → PENDIENTE_DTE', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    final sales = DriftSaleRepository(db);
    final queue = InMemoryDteQueueRepository();
    final certs = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Test',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 30)),
        status: CertificateStatus.valido,
      );
    final transport = FakeSiiTransport(mode: FakeSiiTransportMode.timeout);
    final gateway = SiiLiveDteGateway(
      sales: sales,
      certificates: certs,
      folios: InMemoryFolioAllocator(),
      transport: transport,
      emisor: const SiiEmisorConfig(
        rutEmisor: '76192083-9',
        razonSocial: 'Piloto',
        giro: 'Comercio',
      ),
    );
    final sale = await _seedSale(sales, storeId);
    final updated = await emitSaleDte(sale, gateway, queue);
    expect(updated.dteStatus, DteStatus.pendienteDte);
    expect(await queue.listPending(storeId), hasLength(1));
  });

  test('SC-080-05 transport rechazo → RECHAZADA_SII', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(() async => db.close());
    final sales = DriftSaleRepository(db);
    final queue = InMemoryDteQueueRepository();
    final certs = InMemoryCertificateStore()
      ..info = CertificateInfo(
        subject: 'CN=Test',
        validFrom: DateTime.now().toUtc().subtract(const Duration(days: 1)),
        validTo: DateTime.now().toUtc().add(const Duration(days: 30)),
        status: CertificateStatus.valido,
      );
    final gateway = SiiLiveDteGateway(
      sales: sales,
      certificates: certs,
      folios: InMemoryFolioAllocator(),
      transport: FakeSiiTransport(mode: FakeSiiTransportMode.rechazada),
      emisor: const SiiEmisorConfig(
        rutEmisor: '76192083-9',
        razonSocial: 'Piloto',
        giro: 'Comercio',
      ),
    );
    final sale = await _seedSale(sales, storeId);
    final updated = await emitSaleDte(sale, gateway, queue);
    expect(updated.dteStatus, DteStatus.rechazadaSii);
    expect(await queue.listPending(storeId), isEmpty);
  });

  test('live gateway éxito asigna folio y EMITIDA', () async {
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
    final gateway = SiiLiveDteGateway(
      sales: sales,
      certificates: certs,
      folios: InMemoryFolioAllocator(initialNext: 42),
      transport: FakeSiiTransport(),
      emisor: const SiiEmisorConfig(
        rutEmisor: '76192083-9',
        razonSocial: 'Piloto',
        giro: 'Comercio',
      ),
    );
    final sale = await _seedSale(sales, storeId);
    final result = await gateway.emit(DteEmitRequest.fromSale(sale));
    expect(result.status, DteStatus.emitida);
    expect(result.folio, 42);
  });
}

Future<Sale> _seedSale(DriftSaleRepository sales, StoreId storeId) async {
  final sale = Sale(
    id: 'sale_live_01',
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