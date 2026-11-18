import 'package:uuid/uuid.dart';

typedef ProductId = String;

const _uuid = Uuid();

ProductId newProductId() => _uuid.v4();