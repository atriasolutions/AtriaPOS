enum InventoryCountLineStatus {
  sinContar,
  contado,
  diferencias,
}

class InventoryCountLineResolution {
  const InventoryCountLineResolution({
    required this.status,
    this.delta,
  });

  final InventoryCountLineStatus status;
  /// Diferencia contado − stock sistema; solo si [status] es [InventoryCountLineStatus.diferencias].
  final int? delta;
}

/// Deriva el estado visual de un ítem de conteo.
InventoryCountLineResolution resolveInventoryCountLineStatus(
  int systemStock,
  int? countedQty,
) {
  if (countedQty == null) {
    return const InventoryCountLineResolution(
      status: InventoryCountLineStatus.sinContar,
    );
  }
  final delta = countedQty - systemStock;
  if (delta == 0) {
    return const InventoryCountLineResolution(
      status: InventoryCountLineStatus.contado,
      delta: 0,
    );
  }
  return InventoryCountLineResolution(
    status: InventoryCountLineStatus.diferencias,
    delta: delta,
  );
}