import 'dart:async';
import 'dart:io' show File, InternetAddress, Platform;

import 'package:adapters/adapters.dart';
import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:core/atria_pos_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;

import '../config/companion_lan_config.dart';
import '../config/store_config.dart';
import '../scanner/ble_central_scanner_ingress.dart';
import '../scanner/lan_scanner_ingress.dart';
import '../scanner/scanner_ingress.dart';
import '../widgets/companion_qr_panel.dart';

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
    required this.scanSessionService,
    required this.dteService,
    required this.fiscalService,
    required this.collaboratorService,
    required this.certificateStore,
    required this.reportService,
    required this.trustedClock,
    required this.scannerIngress,
    required this.companionService,
    this.companionLanServer,
    this.companionLanCertStorePath,
    required this.createCompanionOffer,
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
  final ScanSessionService scanSessionService;
  final DteService dteService;
  final FiscalService fiscalService;
  final CollaboratorService collaboratorService;
  final CertificateStore certificateStore;
  final ReportService reportService;
  final NtpShoaTrustedClock trustedClock;
  final ScannerIngress scannerIngress;
  final CompanionService companionService;
  final CompanionLanServer? companionLanServer;

  /// Carpeta de datos del POS para certificados companion (`companion-lan/`).
  final String? companionLanCertStorePath;
  final CreateCompanionPairingOffer createCompanionOffer;

  /// Companion LAN como escáner por defecto en Windows (SLICE-104).
  static bool lanCompanionDefault = true;

  /// HTTPS en companion LAN (DEC-059); tests usan `false`.
  static bool lanCompanionTls = true;

  /// Host anunciado en QR; vacío = autodetectar en `prepareCompanionQr`.
  static String companionAdvertisedHost = '';

  @visibleForTesting
  static int prepareCompanionQrCallCount = 0;

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

  /// Callback cuando la sesión expira o el usuario solicita re-login (SLICE-82).
  void Function()? onSessionExpired;

  void notifySessionExpired() => onSessionExpired?.call();

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
    return PosComposition._fromDatabase(
      db,
      companionDataDir: File(path).parent.path,
    );
  }

  factory PosComposition.fromDatabase(AppDatabase db) =>
      PosComposition._fromDatabase(db);

  static PosComposition _fromDatabase(
    AppDatabase db, {
    DteGateway? dteGatewayOverride,
    CertificateStore? certificateStoreOverride,
    ScannerIngress? scannerIngressOverride,
    NtpShoaTrustedClock? trustedClockOverride,
    String? companionDataDir,
  }) {
    final storeRepo = DriftStoreRepository(db);
    final carts = InMemoryCartRepository();
    final products = DriftProductRepository(db);
    final sales = DriftSaleRepository(db);
    final movements = DriftStockMovementRepository(db);
    final shifts = DriftShiftRepository(db);
    final collaborators = DriftCollaboratorRepository(db);
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
      shiftRepository: shifts,
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
    final companionLiveRegistry = CompanionLanLiveRegistry();
    final companionService =
        CompanionService(liveSessions: companionLiveRegistry);
    final createCompanionOffer =
        CreateCompanionPairingOffer(companionService.repository);
    CompanionLanServer? companionLanServer;
    final ScannerIngress scannerIngress;
    if (scannerIngressOverride != null) {
      scannerIngress = scannerIngressOverride;
    } else if (_useLanCompanionDefault()) {
      companionLanServer = _createCompanionLanServer(
        companionService,
        products,
        companionDataDir,
        companionLiveRegistry,
      );
      scannerIngress = LanScannerIngress(companionLanServer.scans);
    } else {
      scannerIngress = _defaultScannerIngress();
    }
    final scanSessions = InMemoryScanSessionRepository();

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
        collaboratorRepository: collaborators,
        storeRepository: storeRepo,
        productExchangeRepository: DriftProductExchangeRepository(db),
        creditNoteRepository: DriftCreditNoteRepository(db),
        dteGateway: dteGateway,
        dteQueueRepository: dteQueue,
        sessionProvider: sessions,
        clock: trustedClock,
        invoiceCustomerRepository: DriftInvoiceCustomerRepository(db),
      ),
      inventoryService: InventoryService(
        productRepository: products,
        stockMovementRepository: movements,
        shiftRepository: shifts,
        saleRepository: sales,
        inventoryCloseRepository: DriftInventoryCloseRepository(db),
        sessionProvider: sessions,
      ),
      scanSessionService: ScanSessionService(
        scanSessions: scanSessions,
        products: products,
        stockMovements: movements,
        shiftRepository: shifts,
        saleRepository: sales,
        inventoryCloseRepository: DriftInventoryCloseRepository(db),
        sessionProvider: sessions,
      ),
      dteService: DteService(
        queueRepository: dteQueue,
        saleRepository: sales,
        creditNoteRepository: DriftCreditNoteRepository(db),
        dteGateway: dteGateway,
      ),
      fiscalService: FiscalService(
        certificateStore: certificateStore,
        sessionProvider: sessions,
      ),
      collaboratorService: CollaboratorService(
        repository: collaborators,
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
      companionService: companionService,
      companionLanServer: companionLanServer,
      companionLanCertStorePath: companionDataDir,
      createCompanionOffer: createCompanionOffer,
    );
  }

  Future<void> ensureCompanionLanServerStarted() async {
    final server = companionLanServer;
    if (server == null || server.isRunning) return;
    await server.start();
  }

  StoreId get _companionStoreId => activeStoreId ?? kDemoStoreId;

  Future<CompanionLanStatus> fetchCompanionLanStatus() =>
      companionService.getLanStatus(_companionStoreId);

  Future<void> disconnectCompanionLan() =>
      companionService.disconnectLan(_companionStoreId);

  Stream<CompanionLanStatus> companionLanStatusStream() {
    final server = companionLanServer;
    final storeId = _companionStoreId;
    if (server == null) {
      return Stream.value(
        CompanionLanStatus(storeId: storeId, phase: CompanionLanPhase.none),
      );
    }
    return Stream.multi((controller) async {
      Future<void> emit() async {
        if (controller.isClosed) return;
        controller.add(await companionService.getLanStatus(storeId));
      }

      await emit();
      final sub = server.companionStatusChanges.listen((_) => unawaited(emit()));
      controller.onCancel = sub.cancel;
    });
  }

  Future<CompanionQrState?> prepareCompanionQr(CompanionMode mode) async {
    prepareCompanionQrCallCount++;
    await ensureCompanionLanServerStarted();
    final server = companionLanServer;
    if (server == null) return null;
    if (lanCompanionTls && !CompanionLanConfig.hasValidCompanionWebBuild()) {
      return CompanionQrState.blocked(
        reason: CompanionQrBlockedReason.pwaMissing,
        serverRunning: server.isRunning,
      );
    }
    final storeId = activeStoreId ?? kDemoStoreId;
    final offer = await createCompanionOffer(
      CreateCompanionPairingOfferInput(storeId: storeId, mode: mode),
    );
    final port = server.boundPort ?? CompanionLanConstants.defaultPort;
    final endpoint = await CompanionLanConfig.resolveAdvertisedEndpoint();
    final host = endpoint.host;
    if (CompanionLanConfig.advertisedHostOverride.trim().isNotEmpty) {
      companionAdvertisedHost = host;
    }
    final scheme = server.usesTls ? 'https' : 'http';
    final base = Uri(
      scheme: scheme,
      host: host,
      port: port,
    );
    final launchUrl = buildCompanionLaunchUrl(
      base: base,
      pairingCode: offer.pairingCode,
    );
    var certIpMismatch = false;
    final certPath = companionLanCertStorePath;
    if (server.usesTls && certPath != null) {
      final stored = CompanionLanCertStore(certPath).storedServerIpSync();
      if (stored != null && stored.isNotEmpty && stored != host) {
        certIpMismatch = true;
      }
    }
    final caInstallUrl = server.usesTls
        ? base.replace(path: CompanionLanServer.caInstallHelpPath).toString()
        : null;
    return CompanionQrState(
      launchUrl: launchUrl,
      pairingCode: offer.pairingCode,
      serverRunning: server.isRunning,
      blockedReason: null,
      caInstallUrl: caInstallUrl,
      certIpMismatch: certIpMismatch,
      advertisedHost: host,
      advertisedInterface: endpoint.interfaceName,
    );
  }

  static bool _useLanCompanionDefault() {
    return !kIsWeb && Platform.isWindows && lanCompanionDefault;
  }

  static CompanionLanServer _createCompanionLanServer(
    CompanionService service,
    DriftProductRepository products,
    String? dataDir,
    CompanionLanLiveRegistry liveRegistry,
  ) {
    final resolveScan = ResolveScanCode(products);
    if (!lanCompanionTls) {
      return CompanionLanServer(
        companionService: service,
        liveRegistry: liveRegistry,
        resolveScanCode: resolveScan,
        host: InternetAddress.loopbackIPv4.address,
        port: 0,
      );
    }
    final certIp = CompanionLanConfig.resolveAdvertisedHostSync();
    final material = dataDir == null
        ? CompanionLanTlsMaterial.forTest(ip: certIp)
        : CompanionLanCertStore(dataDir).tlsMaterialForServerIpSync(certIp);
    final port = CompanionLanConfig.lanPortOverrideForTests ??
        (CompanionLanConfig.lanPort > 0
            ? CompanionLanConfig.lanPort
            : CompanionLanConstants.defaultPort);
    return CompanionLanServer(
      companionService: service,
      liveRegistry: liveRegistry,
      resolveScanCode: resolveScan,
      host: CompanionLanConfig.bindHost,
      port: port,
      staticRoot: CompanionLanConfig.resolveCompanionWebRoot(),
      securityContext: material.securityContext,
      caPem: material.caPem,
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
  Future<void> ensureDemoStore({
    PosTemplateId templateId = PosTemplateId.atriaPos,
  }) async {
    final existing = await stores.findById(kDemoStoreId);
    if (existing != null && existing.posTemplateId == templateId) {
      await refreshActiveStore();
      return;
    }
    if (existing != null) {
      await (database.delete(database.stores)
            ..where((t) => t.id.equals(kDemoStoreId)))
          .go();
    } else if (await stores.count() > 0) {
      await database.delete(database.stores).go();
    }
    final store = templateId == PosTemplateId.atriaPos
        ? Store.create(
            id: kDemoStoreId,
            rutRaw: '12.345.678-5',
            legalName: 'Tienda demo',
            businessLine: 'Comercio',
          )
        : Store(
            id: kDemoStoreId,
            rut: '12.345.678-5',
            legalName: 'Tienda demo',
            businessLine: 'Comercio',
            taxConfig: const TaxConfig(),
            createdAt: DateTime.utc(2026, 1, 1),
            posTemplateId: templateId,
          );
    await stores.save(store);
    activeStoreId = kDemoStoreId;
  }

  Future<PosTemplateId> resolveActiveTemplateId() async {
    final storeId = activeStoreId ?? await storeService.activeStoreId();
    if (storeId == null) return PosTemplateId.atriaPos;
    final store = await stores.findById(storeId);
    return store?.posTemplateId ?? PosTemplateId.atriaPos;
  }

  Future<void> ensureDemoUsers() async {
    final storeId = activeStoreId ?? kDemoStoreId;
    final hasher = BcryptPinHasher();
    final hash = hasher.hash(demoPin);
    for (final def in [
      (
        id: 'a0000000-0000-4000-8000-000000000001',
        username: 'usr_dueno',
        role: UserRole.dueno,
        firstName: 'Dueño',
        lastName: 'Demo',
      ),
      (
        id: 'a0000000-0000-4000-8000-000000000002',
        username: 'usr_supervisor',
        role: UserRole.supervisor,
        firstName: 'Supervisor',
        lastName: 'Demo',
      ),
      (
        id: 'a0000000-0000-4000-8000-000000000003',
        username: 'usr_cajero',
        role: UserRole.cajero,
        firstName: 'Cajero',
        lastName: 'Demo',
      ),
    ]) {
      final existing = await users.findByUsername(storeId, def.username);
      if (existing != null) continue;
      await users.save(
        User(
          id: def.id,
          storeId: storeId,
          role: def.role,
          pinHash: hash,
          username: def.username,
          firstName: def.firstName,
          lastName: def.lastName,
          rut: '12.345.678-5',
          createdAt: DateTime.utc(2026, 1, 1),
        ),
      );
    }
  }

  /// Colaborador demo V01 para checkout y tests.
  Future<void> ensureDemoSeller() async {
    final storeId = activeStoreId ?? kDemoStoreId;
    final repo = DriftCollaboratorRepository(database);
    final code = SellerCodePolicy.normalize('V01');
    final existing = await repo.findActiveBySellerCode(storeId, code);
    if (existing != null) return;
    await repo.save(
      Collaborator.create(
        storeId: storeId,
        sellerCode: code,
        firstName: 'Colab',
        lastName: 'Demo',
      ),
    );
  }

  Future<void> close() async {
    companionLanServer?.dispose();
    scannerIngress.dispose();
    await closePosDatabase(database);
  }

  static ScannerIngress _defaultScannerIngress() {
    if (!kIsWeb && Platform.isWindows) {
      return BleCentralScannerIngress();
    }
    return StreamScannerIngress();
  }
}