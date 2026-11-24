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

class InventoryClosePreviewItemResponse {
  const InventoryClosePreviewItemResponse({
    required this.productId,
    required this.name,
    required this.systemStock,
    required this.unitsSoldInShift,
  });

  final String productId;
  final String name;
  final int systemStock;
  final int unitsSoldInShift;
}

class InventoryClosePreviewResponse {
  const InventoryClosePreviewResponse({
    required this.shiftId,
    required this.items,
  });

  final String shiftId;
  final List<InventoryClosePreviewItemResponse> items;
}

class InventoryCloseLineRequest {
  const InventoryCloseLineRequest({
    required this.productId,
    required this.countedQty,
  });

  final String productId;
  final int countedQty;
}

class InventoryCloseSubmitRequest {
  const InventoryCloseSubmitRequest({required this.lines});

  final List<InventoryCloseLineRequest> lines;
}

class InventoryCloseLineResponse {
  const InventoryCloseLineResponse({
    required this.productId,
    required this.systemStock,
    required this.countedStock,
    required this.variance,
    required this.unitsSoldInShift,
  });

  final String productId;
  final int systemStock;
  final int countedStock;
  final int variance;
  final int unitsSoldInShift;
}

class InventoryCloseSubmitResponse {
  const InventoryCloseSubmitResponse({
    required this.closeId,
    required this.shiftId,
    required this.closedAt,
    required this.lines,
  });

  final String closeId;
  final String shiftId;
  final String closedAt;
  final List<InventoryCloseLineResponse> lines;
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