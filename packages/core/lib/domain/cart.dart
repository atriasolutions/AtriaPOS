import 'cart_id.dart';
import 'cart_line.dart';
import 'cart_line_id.dart';
import 'store_id.dart';

enum CartStatus { open, completed }

class Cart {
  Cart({
    required this.id,
    required this.storeId,
    required this.lines,
    this.status = CartStatus.open,
    this.shiftId,
    this.userId,
  });

  final CartId id;
  final StoreId storeId;
  final List<CartLine> lines;
  final CartStatus status;
  final String? shiftId;
  final String? userId;

  bool get isEmpty => lines.isEmpty;

  Cart addLine(CartLine line) => Cart(
        id: id,
        storeId: storeId,
        lines: [...lines, line],
        status: status,
        shiftId: shiftId,
        userId: userId,
      );

  Cart updateLine(CartLineId lineId, int quantity) {
    final updated = lines.map((line) {
      if (line.lineId == lineId) return line.withQuantity(quantity);
      return line;
    }).toList();
    return Cart(
      id: id,
      storeId: storeId,
      lines: updated,
      status: status,
      shiftId: shiftId,
      userId: userId,
    );
  }

  Cart removeLine(CartLineId lineId) {
    return Cart(
      id: id,
      storeId: storeId,
      lines: lines.where((l) => l.lineId != lineId).toList(),
      status: status,
      shiftId: shiftId,
      userId: userId,
    );
  }

  Cart markCompleted() => Cart(
        id: id,
        storeId: storeId,
        lines: lines,
        status: CartStatus.completed,
        shiftId: shiftId,
        userId: userId,
      );
}