import 'package:uuid/uuid.dart';

typedef ShiftId = String;

const _uuid = Uuid();

ShiftId newShiftId() => _uuid.v4();