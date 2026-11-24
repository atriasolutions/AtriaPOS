import 'package:uuid/uuid.dart';

typedef InventoryCloseId = String;
typedef InventoryCloseLineId = String;

const _uuid = Uuid();

InventoryCloseId newInventoryCloseId() => _uuid.v4();
InventoryCloseLineId newInventoryCloseLineId() => _uuid.v4();