import 'package:uuid/uuid.dart';

typedef ScanSessionId = String;

const _uuid = Uuid();

ScanSessionId newScanSessionId() => 'scan_${_uuid.v4()}';