import 'package:flutter/material.dart';

import '../config/store_config_sections.dart';
import '../menu/pos_menu_ui.dart';
import '../theme/options_category_style.dart';

class AtriaSectionHeader extends StatelessWidget {
  const AtriaSectionHeader({
    super.key,
    required this.title,
    required this.accentColor,
  })  : _menuCategory = null,
        _storeSection = null;

  AtriaSectionHeader.forMenuCategory({
    super.key,
    required PosMenuCategory category,
    String? title,
  })  : title = title ?? categoryTitle(category),
        accentColor = null,
        _menuCategory = category,
        _storeSection = null;

  AtriaSectionHeader.forStoreSection({
    super.key,
    required StoreConfigSection section,
    String? title,
  })  : title = title ?? storeConfigSectionTitle(section),
        accentColor = null,
        _menuCategory = null,
        _storeSection = section;

  final String title;
  final Color? accentColor;
  final PosMenuCategory? _menuCategory;
  final StoreConfigSection? _storeSection;

  Color _resolveAccent(ColorScheme scheme) {
    if (accentColor != null) return accentColor!;
    if (_menuCategory != null) {
      return OptionsCategoryStyle.forCategory(scheme, _menuCategory!)
          .sectionAccent;
    }
    final menuCategory = switch (_storeSection!) {
      StoreConfigSection.ventas => PosMenuCategory.ventas,
      StoreConfigSection.inventario => PosMenuCategory.inventario,
      StoreConfigSection.fiscal => PosMenuCategory.fiscal,
    };
    return OptionsCategoryStyle.forCategory(scheme, menuCategory).sectionAccent;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = _resolveAccent(scheme);

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 22,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}