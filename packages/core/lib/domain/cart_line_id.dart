import 'package:uuid/uuid.dart';

typedef CartLineId = String;

const _uuid = Uuid();

CartLineId newCartLineId() => _uuid.v4();