import 'package:adapters/adapters.dart';
import 'package:core/api/api.dart';
import 'package:core/application/application.dart';
import 'package:core/domain/domain.dart';
import 'package:core/pos_barrio_core.dart';

import '../config/store_config.dart';

/// Cableado local-first: Drift + carrito in-memory + DTE fake.
class PosComposition {
  PosComposition._({
    required this.database,
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
    required this.productService,
    required this.shiftService,
    required this.saleService,
    required this.inventoryService,
  });

  final AppDatabase database;
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

  final ProductService productService;
  final ShiftService shiftService;
  final SaleService saleService;
  final InventoryService inventoryService;

  /// PIN demo documentado en ADR (solo desarrollo).
  static const demoPin = '2468';

  factory PosComposition.memory() {
    final db = openPosDatabaseMemory();
    return PosComposition._fromDatabase(db);
  }

  factory PosComposition.file(String path) {
    final db = openPosDatabaseFile(path);
    return PosComposition._fromDatabase(db);
  }

  factory PosComposition.fromDatabase(AppDatabase db) =>
      PosComposition._fromDatabase(db);

  static PosComposition _fromDatabase(AppDatabase db) {
    final carts = InMemoryCartRepository();
    final products = DriftProductRepository(db);
    final sales = DriftSaleRepository(db);
    final movements = DriftStockMovementRepository(db);
    final shifts = DriftShiftRepository(db);
    final dteQueue = DriftDteQueueRepository(db);
    final dteGateway = createDteGateway(sales: sales, database: db);
    final users = DriftUserRepository(db);
    final sessions = InMemorySessionProvider();
    final hasher = BcryptPinHasher();
    final auth = AuthService(
      userRepository: users,
      pinHasher: hasher,
      sessionProvider: sessions,
    );

    return PosComposition._(
      database: db,
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
      productService: ProductService(
        repository: products,
        sessionProvider: sessions,
      ),
      shiftService: ShiftService(
        shiftRepository: shifts,
        saleRepository: sales,
        sessionProvider: sessions,
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
      ),
      inventoryService: InventoryService(
        productRepository: products,
        stockMovementRepository: movements,
        sessionProvider: sessions,
      ),
    );
  }

  Future<void> ensureDemoUsers() async {
    final hasher = BcryptPinHasher();
    final hash = hasher.hash(demoPin);
    for (final def in [
      (id: 'usr_dueno', role: UserRole.dueno, name: 'Dueño'),
      (id: 'usr_supervisor', role: UserRole.supervisor, name: 'Supervisor'),
      (id: 'usr_cajero', role: UserRole.cajero, name: 'Cajero'),
    ]) {
      final existing = await users.findById(kDemoStoreId, def.id);
      if (existing != null) continue;
      await users.save(
        User(
          id: def.id,
          storeId: kDemoStoreId,
          role: def.role,
          pinHash: hash,
          displayName: def.name,
        ),
      );
    }
  }

  Future<void> close() => closePosDatabase(database);
}