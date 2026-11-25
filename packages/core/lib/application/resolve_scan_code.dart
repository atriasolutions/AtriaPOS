import '../domain/domain.dart';
import 'ports/product_repository.dart';

class ResolvedScanTarget {
  const ResolvedScanTarget({
    required this.productId,
    required this.productName,
  });

  final ProductId productId;
  final String productName;
}

class ResolveScanCode {
  ResolveScanCode(this._products);

  final ProductRepository _products;

  Future<ResolvedScanTarget> call(StoreId storeId, String rawCode) async {
    final trimmed = rawCode.trim();
    if (trimmed.isEmpty) {
      throw const ValidationFailure('El código escaneado no puede estar vacío');
    }

    final fromQr = parseProductIdFromScan(trimmed);
    if (fromQr != null) {
      final product = await _products.findById(storeId, fromQr);
      if (product != null) {
        return ResolvedScanTarget(
          productId: product.id,
          productName: product.name,
        );
      }
    }

    final byBarcode = await _products.findByBarcode(storeId, trimmed);
    if (byBarcode != null) {
      return ResolvedScanTarget(
        productId: byBarcode.id,
        productName: byBarcode.name,
      );
    }

    throw NotFoundFailure(
      'Producto no encontrado para el código escaneado',
      details: {'code': trimmed, 'canCreateProduct': true},
    );
  }
}