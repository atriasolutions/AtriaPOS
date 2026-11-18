import 'cart_line.dart';

/// Total venta en CLP enteros (DEC-008).
int saleTotalClp(List<CartLine> lines) {
  return lines.fold<int>(0, (sum, line) => sum + line.lineTotalClp);
}