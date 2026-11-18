import 'package:uuid/uuid.dart';

typedef StockMovementId = String;

const _uuid = Uuid();

StockMovementId newStockMovementId() => _uuid.v4();