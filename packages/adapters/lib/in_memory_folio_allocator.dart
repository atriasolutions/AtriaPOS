import 'package:core/atria_pos_core.dart';

import 'caf_file.dart';
import 'folio_allocator.dart';

/// Allocator en memoria para tests y gateway con transport fake.
class InMemoryFolioAllocator implements FolioAllocator {
  InMemoryFolioAllocator({
    CafRange? range,
    CafRange? creditNoteRange,
    int? initialNext,
  })  : _ranges = {
          39: range ?? const CafRange(documentType: 39, desde: 9001, hasta: 9010),
          61: creditNoteRange ??
              const CafRange(documentType: 61, desde: 1, hasta: 500),
        },
        _initialNext = initialNext,
        _nextByKey = {};

  final Map<int, CafRange> _ranges;
  final int? _initialNext;
  final Map<String, int> _nextByKey;

  static String _key(String storeId, int tipo) => '$storeId:$tipo';

  @override
  Future<int> allocateNext(StoreId storeId, int documentType) async {
    final range = _ranges[documentType];
    if (range == null) {
      throw FolioAgotadoException('CAF no configurado para tipo $documentType');
    }
    final key = _key(storeId, documentType);
    final current = _nextByKey[key] ?? _initialNext ?? range.desde;
    if (current > range.hasta) {
      throw FolioAgotadoException('Sin folios disponibles en CAF');
    }
    _nextByKey[key] = current + 1;
    return current;
  }
}