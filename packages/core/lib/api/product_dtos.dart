/// Request alineado a API-001 `POST .../products`.
class CreateProductRequest {
  const CreateProductRequest({
    required this.name,
    required this.salePriceClp,
    this.costClp,
    this.barcode,
    this.initialStock = 0,
    this.blockWhenOutOfStock = true,
  });

  final String name;
  final int salePriceClp;
  final int? costClp;
  final String? barcode;
  final int initialStock;
  final bool blockWhenOutOfStock;
}

class ProductResponse {
  const ProductResponse({
    required this.id,
    required this.name,
    required this.salePriceClp,
    required this.stock,
    this.qrPayload,
  });

  final String id;
  final String name;
  final int salePriceClp;
  final int stock;
  final String? qrPayload;
}

class ProductSearchItem {
  const ProductSearchItem({
    required this.id,
    required this.name,
    required this.salePriceClp,
    required this.stock,
  });

  final String id;
  final String name;
  final int salePriceClp;
  final int stock;
}

class SearchProductsResponse {
  const SearchProductsResponse({required this.items});

  final List<ProductSearchItem> items;
}