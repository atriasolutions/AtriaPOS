import 'package:uuid/uuid.dart';

typedef SaleId = String;

const _uuid = Uuid();

SaleId newSaleId() => _uuid.v4();