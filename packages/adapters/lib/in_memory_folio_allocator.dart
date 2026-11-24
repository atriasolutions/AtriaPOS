import 'package:core/atria_pos_core.dart';

import 'caf_file.dart';
import 'folio_allocator.dart';

/// Allocator en memoria para tests y gateway con transport fake.
class InMemoryFolioAllocator implements FolioAllocator {
  InMemoryFolioAllocator({
    CafRange? range,
    int? initialNext,
  })  : _range = range ??
            const CafRange(documentType: 39, desde: 9001, hasta: 9010),
        _initialNext = initialNext,
        _nextByKey = {};

  final CafRange _range;
  final int? _initialNext;
  final Map<String, int> _nextByKey;

  static String _key(String storeId, int tipo) => '$storeId:$tipo';

  @override
  Future<int> allocateNext(StoreId storeId, int documentType) async {
    final key = _key(storeId, documentType);
    final current = _nextByKey[key] ?? _initialNext ?? _range.desde;
    if (current > _range.hasta) {
      throw FolioAgotadoException('Sin folios disponibles en CAF');
    }
    _nextByKey[key] = current + 1;
    return current;
  }
}