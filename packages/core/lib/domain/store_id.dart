import 'package:uuid/uuid.dart';

typedef StoreId = String;

const _uuid = Uuid();

StoreId newStoreId() => _uuid.v4();