import 'inventory_close_id.dart';
import 'product_id.dart';
import 'shift_id.dart';
import 'store_id.dart';
import 'user_id.dart';

class InventoryCloseLine {
  const InventoryCloseLine({
    required this.id,
    required this.productId,
    required this.systemStock,
    required this.countedStock,
    required this.variance,
    required this.unitsSoldInShift,
  });

  final InventoryCloseLineId id;
  final ProductId productId;
  final int systemStock;
  final int countedStock;
  final int variance;
  final int unitsSoldInShift;
}

class InventoryClose {
  const InventoryClose({
    required this.id,
    required this.storeId,
    required this.shiftId,
    required this.createdAt,
    required this.actorUserId,
    required this.lines,
  });

  final InventoryCloseId id;
  final StoreId storeId;
  final ShiftId shiftId;
  final DateTime createdAt;
  final UserId actorUserId;
  final List<InventoryCloseLine> lines;
}