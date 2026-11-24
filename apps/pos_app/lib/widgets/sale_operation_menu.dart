import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../menu/pos_menu_ui.dart';

class SaleOperationMenu extends StatelessWidget {
  const SaleOperationMenu({
    super.key,
    required this.composition,
    required this.visibleEntries,
    this.menuAnchor,
  });

  final PosComposition composition;
  final List<PosMenuEntry> visibleEntries;
  final Widget? menuAnchor;

  @override
  Widget build(BuildContext context) {
    final popupEntries = sortMenuEntries(visibleEntries)
        .where((e) => e != PosMenuEntry.productCreate)
        .toList();
    if (popupEntries.isEmpty) return const SizedBox.shrink();

    return PopupMenuButton<String>(
      key: const Key('operation_menu_button'),
      tooltip: 'Operación',
      onSelected: (value) {
        final entry = popupEntries.firstWhere(
          (e) => popupValueFor(e) == value,
        );
        navigateForMenuEntry(context, composition, entry);
      },
      itemBuilder: (context) =>
          popupEntries.map(buildPopupMenuItem).toList(),
      child: menuAnchor,
    );
  }
}