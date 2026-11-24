import 'package:uuid/uuid.dart';

typedef UserId = String;

const _uuid = Uuid();

UserId newUserId() => _uuid.v4();