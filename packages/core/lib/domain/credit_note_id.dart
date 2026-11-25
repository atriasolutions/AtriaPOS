import 'package:uuid/uuid.dart';

typedef CreditNoteId = String;

const _uuid = Uuid();

CreditNoteId newCreditNoteId() => _uuid.v4();