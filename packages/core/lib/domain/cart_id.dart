import 'package:uuid/uuid.dart';

typedef CartId = String;

const _uuid = Uuid();

CartId newCartId() => _uuid.v4();