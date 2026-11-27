import 'package:core/domain/domain.dart';

/// Etiqueta corta mientras el código está listo (sin mostrar URL cruda).
String companionScanListoLabel(String raw) {
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return raw;
  if (parseProductIdFromScan(trimmed) != null) {
    return 'producto en caja';
  }
  final uri = Uri.tryParse(trimmed);
  if (uri != null && uri.hasScheme && uri.host.isNotEmpty) {
    return 'código listo';
  }
  return trimmed;
}