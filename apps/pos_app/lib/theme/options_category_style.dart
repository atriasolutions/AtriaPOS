import 'package:flutter/material.dart';

import '../menu/pos_menu_ui.dart';

class OptionsCategoryStyle {
  const OptionsCategoryStyle({
    required this.sectionAccent,
    required this.iconBackground,
    required this.iconForeground,
    required this.tileBackground,
    required this.tileBorder,
  });

  final Color sectionAccent;
  final Color iconBackground;
  final Color iconForeground;
  final Color tileBackground;
  final Color tileBorder;

  static OptionsCategoryStyle forCategory(
    ColorScheme scheme,
    PosMenuCategory category,
  ) {
    return switch (category) {
      PosMenuCategory.ventas => OptionsCategoryStyle(
          sectionAccent: scheme.primary,
          iconBackground: scheme.primary.withValues(alpha: 0.14),
          iconForeground: scheme.primary,
          tileBackground: scheme.surfaceContainerLow,
          tileBorder: scheme.outlineVariant,
        ),
      PosMenuCategory.fiscal => OptionsCategoryStyle(
          sectionAccent: scheme.tertiary,
          iconBackground: scheme.tertiary.withValues(alpha: 0.16),
          iconForeground: scheme.tertiary,
          tileBackground: scheme.surfaceContainerLow,
          tileBorder: scheme.outlineVariant,
        ),
      PosMenuCategory.inventario => OptionsCategoryStyle(
          sectionAccent: scheme.primaryContainer,
          iconBackground: scheme.primaryContainer,
          iconForeground: scheme.onPrimaryContainer,
          tileBackground: scheme.surfaceContainerLow,
          tileBorder: scheme.outlineVariant,
        ),
      PosMenuCategory.administracion => OptionsCategoryStyle(
          sectionAccent: scheme.secondaryContainer,
          iconBackground: scheme.secondaryContainer,
          iconForeground: scheme.onSecondaryContainer,
          tileBackground: scheme.surfaceContainerLow,
          tileBorder: scheme.outlineVariant,
        ),
    };
  }
}