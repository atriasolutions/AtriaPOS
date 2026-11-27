import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import '../menu/pos_menu_ui.dart';
import '../widgets/options_action_tile.dart';
import '../widgets/options_menu_tile.dart';
import '../widgets/section_header.dart';

const _kOptionsContentMaxWidth = 1400.0;

int optionsGridCrossAxisCount(double width) {
  if (width >= 1100) return 6;
  if (width >= 800) return 4;
  if (width >= 520) return 3;
  return 2;
}

double optionsGridChildAspectRatio(double width) {
  if (width >= 1100) return 1.05;
  if (width >= 800) return 1.08;
  return 1.0;
}

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({
    super.key,
    required this.composition,
    required this.visibleEntries,
    this.onChangeSession,
  });

  final PosComposition composition;
  final List<PosMenuEntry> visibleEntries;
  final VoidCallback? onChangeSession;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final sections = groupMenuEntries(visibleEntries);
    if (sections.isEmpty && onChangeSession == null) {
      return Scaffold(
        key: const Key('options_screen'),
        appBar: AppBar(
          title: const Text('Opciones'),
          backgroundColor: scheme.surface,
          foregroundColor: scheme.onSurface,
        ),
        body: const Center(
          child: Text('Sin opciones disponibles para su rol.'),
        ),
      );
    }

    return Scaffold(
      key: const Key('options_screen'),
      appBar: AppBar(
        title: const Text('Opciones'),
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = optionsGridCrossAxisCount(constraints.maxWidth);
          final aspectRatio = optionsGridChildAspectRatio(constraints.maxWidth);
          final horizontalPadding = constraints.maxWidth >= 800 ? 24.0 : 16.0;

          return SingleChildScrollView(
            key: const Key('options_screen_list'),
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              12,
              horizontalPadding,
              28,
            ),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _kOptionsContentMaxWidth),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (sections.isEmpty && onChangeSession != null) ...[
                      AtriaSectionHeader.forMenuCategory(
                        category: PosMenuCategory.ventas,
                        key: const Key('options_section_ventas'),
                      ),
                      const SizedBox(height: 8),
                      _changeSessionTile(context),
                      const SizedBox(height: 20),
                    ],
                    for (final entry in sections.entries) ...[
                      AtriaSectionHeader.forMenuCategory(
                        category: entry.key,
                        key: Key('options_section_${entry.key.name}'),
                      ),
                      const SizedBox(height: 8),
                      Builder(
                        builder: (context) {
                          final extraChangeSession =
                              entry.key == PosMenuCategory.ventas &&
                                  onChangeSession != null;
                          final itemCount =
                              entry.value.length + (extraChangeSession ? 1 : 0);
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: aspectRatio,
                            ),
                            itemCount: itemCount,
                            itemBuilder: (context, index) {
                              if (extraChangeSession &&
                                  index == entry.value.length) {
                                return _changeSessionTile(context);
                              }
                              final item = entry.value[index];
                              return OptionsMenuTile(
                                entry: item,
                                category: entry.key,
                                onTap: () => navigateForMenuEntry(
                                  context,
                                  composition,
                                  item,
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _changeSessionTile(BuildContext context) {
    return OptionsActionTile(
      key: const Key('sale_change_session'),
      title: 'Cambiar sesión',
      icon: Icons.logout,
      category: PosMenuCategory.ventas,
      onTap: () {
        Navigator.of(context).pop();
        onChangeSession?.call();
      },
    );
  }
}