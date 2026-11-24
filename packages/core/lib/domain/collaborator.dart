import 'collaborator_id.dart';
import 'failures.dart';
import 'seller_code_policy.dart';
import 'store_id.dart';

class Collaborator {
  Collaborator({
    required this.id,
    required this.storeId,
    required this.sellerCode,
    required this.firstName,
    required this.lastName,
    this.active = true,
  });

  final CollaboratorId id;
  final StoreId storeId;
  final String sellerCode;
  final String firstName;
  final String lastName;
  final bool active;

  String get displayName =>
      '${firstName.trim()} ${lastName.trim()}'.trim();

  Collaborator withUpdates({
    String? sellerCode,
    String? firstName,
    String? lastName,
    bool? active,
  }) {
    return Collaborator(
      id: id,
      storeId: storeId,
      sellerCode: sellerCode ?? this.sellerCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      active: active ?? this.active,
    );
  }

  static Collaborator create({
    required StoreId storeId,
    required String sellerCode,
    required String firstName,
    required String lastName,
  }) {
    final code = SellerCodePolicy.normalize(sellerCode);
    final fn = firstName.trim();
    final ln = lastName.trim();
    if (fn.isEmpty) {
      throw const ValidationFailure('Ingrese el nombre');
    }
    if (ln.isEmpty) {
      throw const ValidationFailure('Ingrese el apellido');
    }
    return Collaborator(
      id: newCollaboratorId(),
      storeId: storeId,
      sellerCode: code,
      firstName: fn,
      lastName: ln,
    );
  }
}