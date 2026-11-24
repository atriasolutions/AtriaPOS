class StockResponse {
  const StockResponse({
    required this.productId,
    required this.stock,
  });

  final String productId;
  final int stock;
}

class AdjustStockRequest {
  const AdjustStockRequest({
    required this.delta,
    required this.reason,
    this.note,
  });

  final int delta;
  final String reason;
  final String? note;
}

class AdjustStockResponse {
  const AdjustStockResponse({
    required this.productId,
    required this.stock,
    required this.movementId,
  });

  final String productId;
  final int stock;
  final String movementId;
}

class StockReceiptRequest {
  const StockReceiptRequest({
    required this.quantity,
    required this.guideRef,
    required this.lotRef,
  });

  final int quantity;
  final String guideRef;
  final String lotRef;
}

class StockReceiptResponse {
  const StockReceiptResponse({
    required this.productId,
    required this.stock,
    required this.movementId,
    required this.guideRef,
    required this.lotRef,
  });

  final String productId;
  final int stock;
  final String movementId;
  final String guideRef;
  final String lotRef;
}