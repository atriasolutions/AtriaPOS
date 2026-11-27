import 'package:core/application/ports/trusted_clock.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../menu/pos_menu_ui.dart';
import '../screens/product_stock_list_screen.dart';
import 'pos_clock_display.dart';
import 'sale_operation_menu.dart';

class AtriaSaleCommandBar extends StatelessWidget {
  const AtriaSaleCommandBar({
    super.key,
    required this.composition,
    required this.clock,
    required this.visibleEntries,
    this.showProductStock = false,
    this.onChangeSession,
    this.onMenuReturned,
    this.scannerAction,
  });

  final PosComposition composition;
  final TrustedClock clock;
  final List<PosMenuEntry> visibleEntries;
  final bool showProductStock;
  final VoidCallback? onChangeSession;
  final VoidCallback? onMenuReturned;
  final Widget? scannerAction;

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trailingInset = kDebugMode ? 72.0 : 16.0;
    final showProducts = showProductStock;
    final showOptions = optionsMenuEntries(visibleEntries).isNotEmpty ||
        onChangeSession != null;

    final menu = SaleOperationMenu(
      composition: composition,
      visibleEntries: visibleEntries,
      onChangeSession: onChangeSession,
      onNavigated: onMenuReturned,
      menuAnchor: Builder(
        builder: (context) {
          final cs = Theme.of(context).colorScheme;
          return Material(
            color: cs.primary,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.apps, size: 18, color: cs.onPrimary),
                  const SizedBox(width: 6),
                  Text('Opciones', style: TextStyle(color: cs.onPrimary)),
                ],
              ),
            ),
          );
        },
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        border: Border(
          bottom: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 0, trailingInset, 0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 520;
              final actions = Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showOptions) menu,
                  if (showOptions && scannerAction != null)
                    const SizedBox(width: 8),
                  if (scannerAction != null) scannerAction!,
                  if (showProducts) ...[
                    if (showOptions || scannerAction != null)
                      const SizedBox(width: 8),
                    FilledButton.icon(
                      key: const Key('sale_top_products'),
                      onPressed: () => _open(
                        context,
                        ProductStockListScreen(composition: composition),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: scheme.secondary,
                      ),
                      icon: const Icon(Icons.inventory_2_outlined),
                      label: const Text('PRODUCTOS'),
                    ),
                  ],
                ],
              );

              if (narrow) {
                return Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: actions,
                      ),
                    ),
                    const SizedBox(width: 12),
                    PosClockDisplay(clock: clock),
                  ],
                );
              }

              return Row(
                children: [
                  actions,
                  const Spacer(),
                  PosClockDisplay(clock: clock),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Alias temporal para imports existentes.
typedef AtriaSaleTopBar = AtriaSaleCommandBar;