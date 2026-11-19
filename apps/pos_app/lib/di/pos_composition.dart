import 'dart:io' show Platform;

import 'package:adapters/adapters.dart';
import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:core/pos_barrio_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../config/store_config.dart';
import '../scanner/ble_central_scanner_ingress.dart';
import '../scanner/scanner_ingress.dart';

/// Cableado local-first: Drift + carrito in-memory + DTE fake.
class PosComposition {
  PosComposition._({
    required this.database,
    required this.stores,
    required this.carts,
    required this.products,
    required this.sales,
    required this.movements,
    required this.shifts,
    required this.dteQueue,
    required this.dteGateway,
    required this.users,
    required this.sessionProvider,
    required this.authService,
    required this.storeService,
    required this.productService,
    required this.shiftService,
    required this.saleService,
    required this.inventoryService,
    required this.dteService,
    required this.fiscalService,
    required this.certificateStore,
    required this.reportService,
    required this.trustedClock,
    required this.scannerIngress,
  });

  final AppDatabase database;
  final DriftStoreRepository stores;
  final InMemoryCartRepository carts;
  final DriftProductRepository products;
  final DriftSaleRepository sales;
  final DriftStockMovementRepository movements;
  final DriftShiftRepository shifts;
  final DriftDteQueueRepository dteQueue;
  final DteGateway dteGateway;
  final DriftUserRepository users;
  final InMemorySessionProvider sessionProvider;
  final AuthService authService;
  final StoreService storeService;

  final ProductService productService;
  final ShiftService shiftService;
  final SaleService saleService;
  final InventoryService inventoryService;
  final DteService dteService;
  final FiscalService fiscalService;
  final CertificateStore certificateStore;
  final ReportService reportService;
  final NtpShoaTrustedClock trustedClock;
  final ScannerIngress scannerIngress;

  /// Cache del identificador de tienda activa (MVP una tienda).
  String? activeStoreId;

  /// PIN demo documentado en ADR (solo desarrollo).
  static const demoPin = '2468';

  StoreId get requireStoreId {
    final id = activeStoreId;
    if (id == null) {
      throw StateError('No hay tienda activa cargada');
    }
    return id;
  }

  factory PosComposition.memory({
    DteGateway? dteGateway,
    CertificateStore? certificateStore,
    ScannerIngress? scannerIngress,
    NtpShoaTrustedClock? trustedClock,
  }) {
    final db = openPosDatabaseMemory();
    return PosComposition._fromDatabase(
      db,
      dteGatewayOverride: dteGateway,
      certificateStoreOverride: certificateStore,
      scannerIngressOverride: scannerIngress,
      trustedClockOverride: trustedClock,
    );
  }

  factory PosComposition.file(String path) {
    final db = openPosDatabaseFile(path);
    return PosComposition._fromDatabase(db);
  }

  factory PosComposition.fromDatabase(AppDatabase db) =>
      PosComposition._fromDatabase(db);

  static PosComposition _fromDatabase(
    AppDatabase db, {
    DteGateway? dteGatewayOverride,
    CertificateStore? certificateStoreOverride,
    ScannerIngress? scannerIngressOverride,
    NtpShoaTrustedClock? trustedClockOverride,
  }) {
    final storeRepo = DriftStoreRepository(db);
    final carts = InMemoryCartRepository();
    final products = DriftProductRepository(db);
    final sales = DriftSaleRepository(db);
    final movements = DriftStockMovementRepository(db);
    final shifts = DriftShiftRepository(db);
    final dteQueue = DriftDteQueueRepository(db);
    final certificateStore =
        certificateStoreOverride ?? createCertificateStore();
    final dteGateway = dteGatewayOverride ??
        createDteGateway(
          sales: sales,
          database: db,
          stores: storeRepo,
          certificateStoreForReplay: certificateStore,
        );
    final users = DriftUserRepository(db);
    final sessions = InMemorySessionProvider();
    final hasher = BcryptPinHasher();
    final auth = AuthService(
      userRepository: users,
      pinHasher: hasher,
      sessionProvider: sessions,
    );
    final storeSvc = StoreService(
      storeRepository: storeRepo,
      userRepository: users,
      pinHasher: hasher,
      sessionProvider: sessions,
    );
    final clockPersist = DriftClockStateRepository(db);
    final trustedClock = trustedClockOverride ??
        NtpShoaTrustedClock(MutableTrustedClock(), clockPersist);
    final scannerIngress = scannerIngressOverride ?? _defaultScannerIngress();

    return PosComposition._(
      database: db,
      stores: storeRepo,
      carts: carts,
      products: products,
      sales: sales,
      movements: movements,
      shifts: shifts,
      dteQueue: dteQueue,
      dteGateway: dteGateway,
      users: users,
      sessionProvider: sessions,
      authService: auth,
      storeService: storeSvc,
      productService: ProductService(
        repository: products,
        sessionProvider: sessions,
      ),
      shiftService: ShiftService(
        shiftRepository: shifts,
        saleRepository: sales,
        sessionProvider: sessions,
        clock: trustedClock,
      ),
      saleService: SaleService(
        cartRepository: carts,
        productRepository: products,
        saleRepository: sales,
        stockMovementRepository: movements,
        shiftRepository: shifts,
        dteGateway: dteGateway,
        dteQueueRepository: dteQueue,
        sessionProvider: sessions,
        clock: trustedClock,
      ),
      inventoryService: InventoryService(
        productRepository: products,
        stockMovementRepository: movements,
        sessionProvider: sessions,
      ),
      dteService: DteService(
        queueRepository: dteQueue,
        saleRepository: sales,
        dteGateway: dteGateway,
      ),
      fiscalService: FiscalService(
        certificateStore: certificateStore,
        sessionProvider: sessions,
      ),
      certificateStore: certificateStore,
      reportService: ReportService(
        saleRepository: sales,
        stockMovementRepository: movements,
        productRepository: products,
        sessionProvider: sessions,
      ),
      trustedClock: trustedClock,
      scannerIngress: scannerIngress,
    );
  }

  Future<void> bootstrapClock() async {
    await trustedClock.loadPersisted();
    await trustedClock.syncFromNetwork();
  }

  Future<void> refreshActiveStore() async {
    activeStoreId = await storeService.activeStoreId();
  }

  /// Seed para tests de regresión (id fijo `tienda_demo`).
  Future<void> ensureDemoStore() async {
    if (await stores.count() > 0) {
      await refreshActiveStore();
      return;
    }
    final store = Store.create(
      id: kDemoStoreId,
      rutRaw: '12.345.678-5',
      legalName: 'Tienda demo',
      businessLine: 'Comercio',
    );
    await stores.save(store);
    activeStoreId = kDemoStoreId;
  }

  Future<void> ensureDemoUsers() async {
    final storeId = activeStoreId ?? kDemoStoreId;
    final hasher = BcryptPinHasher();
    final hash = hasher.hash(demoPin);
    for (final def in [
      (id: 'usr_dueno', role: UserRole.dueno, name: 'Dueño'),
      (id: 'usr_supervisor', role: UserRole.supervisor, name: 'Supervisor'),
      (id: 'usr_cajero', role: UserRole.cajero, name: 'Cajero'),
    ]) {
      final existing = await users.findById(storeId, def.id);
      if (existing != null) continue;
      await users.save(
        User(
          id: def.id,
          storeId: storeId,
          role: def.role,
          pinHash: hash,
          displayName: def.name,
        ),
      );
    }
  }

  Future<void> close() => closePosDatabase(database);

  static ScannerIngress _defaultScannerIngress() {
    if (!kIsWeb && Platform.isWindows) {
      return BleCentralScannerIngress();
    }
    return StreamScannerIngress();
  }
}