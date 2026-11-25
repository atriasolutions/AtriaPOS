import 'package:uuid/uuid.dart';

typedef ProductExchangeId = String;

const _uuid = Uuid();

ProductExchangeId newProductExchangeId() => _uuid.v4();