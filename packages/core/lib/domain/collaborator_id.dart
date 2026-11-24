import 'package:uuid/uuid.dart';

typedef CollaboratorId = String;

const _uuid = Uuid();

CollaboratorId newCollaboratorId() => _uuid.v4();