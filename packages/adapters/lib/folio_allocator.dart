import 'package:core/atria_pos_core.dart';

/// Error controlado al agotar rango CAF.
class FolioAgotadoException implements Exception {
  FolioAgotadoException(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Asigna el siguiente folio DTE para una tienda.
abstract class FolioAllocator {
  Future<int> allocateNext(StoreId storeId, int documentType);
}