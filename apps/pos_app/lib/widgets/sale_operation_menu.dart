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
    this.onNavigated,
    this.onChangeSession,
  });

  final PosComposition composition;
  final List<PosMenuEntry> visibleEntries;
  final Widget? menuAnchor;
  final VoidCallback? onNavigated;
  final VoidCallback? onChangeSession;

  @override
  Widget build(BuildContext context) {
    if (optionsMenuEntries(visibleEntries).isEmpty && onChangeSession == null) {
      return const SizedBox.shrink();
    }

    return Tooltip(
      message: 'Opciones',
      child: InkWell(
        key: const Key('operation_menu_button'),
        onTap: () async {
          await openOptionsScreen(
            context,
            composition,
            visibleEntries,
            onChangeSession: onChangeSession,
          );
          onNavigated?.call();
        },
        borderRadius: BorderRadius.circular(20),
        child: menuAnchor,
      ),
    );
  }
}