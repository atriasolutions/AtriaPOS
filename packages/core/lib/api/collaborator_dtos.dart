class CreateCollaboratorRequest {
  const CreateCollaboratorRequest({
    required this.sellerCode,
    required this.firstName,
    required this.lastName,
  });

  final String sellerCode;
  final String firstName;
  final String lastName;
}

class UpdateCollaboratorRequest {
  const UpdateCollaboratorRequest({
    this.sellerCode,
    this.firstName,
    this.lastName,
    this.active,
  });

  final String? sellerCode;
  final String? firstName;
  final String? lastName;
  final bool? active;
}

class CollaboratorResponse {
  const CollaboratorResponse({
    required this.id,
    required this.sellerCode,
    required this.firstName,
    required this.lastName,
    required this.active,
  });

  final String id;
  final String sellerCode;
  final String firstName;
  final String lastName;
  final bool active;
}

class ListCollaboratorsResponse {
  const ListCollaboratorsResponse({required this.items});

  final List<CollaboratorResponse> items;
}