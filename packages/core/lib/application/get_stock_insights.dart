import '../domain/domain.dart';
import 'auth_helpers.dart';
import 'ports/product_repository.dart';
import 'ports/sale_repository.dart';
import 'ports/session_provider.dart';

class StockInsightsLowStockItem {
  const StockInsightsLowStockItem({
    required this.productId,
    required this.name,
    required this.stock,
    required this.lowStockThreshold,
    required this.salePriceClp,
  });

  final ProductId productId;
  final String name;
  final int stock;
  final int lowStockThreshold;
  final int salePriceClp;
}

class StockInsightsTopSellerItem {
  const StockInsightsTopSellerItem({
    required this.productId,
    required this.name,
    required this.unitsSold,
  });

  final ProductId productId;
  final String name;
  final int unitsSold;
}

class StockInsights {
  const StockInsights({
    required this.asOfLocal,
    required this.periodDays,
    required this.defaultLowStockThreshold,
    required this.lowStock,
    required this.topSellers,
  });

  final DateTime asOfLocal;
  final int periodDays;
  final int defaultLowStockThreshold;
  final List<StockInsightsLowStockItem> lowStock;
  final List<StockInsightsTopSellerItem> topSellers;
}

class GetStockInsights {
  GetStockInsights(this._products, this._sales, this._sessions);

  final ProductRepository _products;
  final SaleRepository _sales;
  final SessionProvider _sessions;

  static const maxTopLimit = 50;

  Future<StockInsights> call(
    StoreId storeId, {
    DateTime? asOfLocal,
    int topLimit = 10,
  }) async {
    AuthPolicy.require(
      requireActiveSession(_sessions),
      Permission.consultarReportes,
    );

    if (topLimit < 1 || topLimit > maxTopLimit) {
      throw ValidationFailure(
        'El límite de ranking debe estar entre 1 y $maxTopLimit',
      );
    }

    final asOf = asOfLocal ?? DateTime.now();
    final asOfMidnight = DateTime(asOf.year, asOf.month, asOf.day);
    final fromUtc = TopSalesPeriodPolicy.fromInclusiveUtc(asOfMidnight);
    final toUtc = TopSalesPeriodPolicy.toExclusiveUtc(asOfMidnight);

    final allProducts = await _products.listByStore(storeId);
    final lowStock = <StockInsightsLowStockItem>[];
    for (final product in allProducts) {
      if (!LowStockPolicy.isLowStock(product)) continue;
      lowStock.add(
        StockInsightsLowStockItem(
          productId: product.id,
          name: product.name,
          stock: product.stock,
          lowStockThreshold: LowStockPolicy.effectiveThreshold(product),
          salePriceClp: product.salePriceClp,
        ),
      );
    }

    final ranks = await _sales.topProductsByUnits(
      storeId,
      fromUtc,
      toUtc,
      topLimit,
    );
    final topSellers = <StockInsightsTopSellerItem>[];
    for (final rank in ranks) {
      final product = await _products.findById(storeId, rank.productId);
      topSellers.add(
        StockInsightsTopSellerItem(
          productId: rank.productId,
          name: product?.name ?? rank.productId,
          unitsSold: rank.unitsSold,
        ),
      );
    }
    topSellers.sort((a, b) {
      final byUnits = b.unitsSold.compareTo(a.unitsSold);
      if (byUnits != 0) return byUnits;
      return a.name.compareTo(b.name);
    });

    return StockInsights(
      asOfLocal: asOfMidnight,
      periodDays: TopSalesPeriodPolicy.periodDays,
      defaultLowStockThreshold: LowStockPolicy.defaultLowStockThreshold,
      lowStock: lowStock,
      topSellers: topSellers,
    );
  }
}