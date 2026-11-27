import 'package:flutter/material.dart';

import '../menu/pos_menu_ui.dart';
import '../theme/atria_touch_targets.dart';
import '../theme/options_category_style.dart';

class OptionsActionTile extends StatelessWidget {
  const OptionsActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.category,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final PosMenuCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final style = OptionsCategoryStyle.forCategory(scheme, category);
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: style.tileBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: style.tileBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: kMinTouchHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: style.iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      icon,
                      size: 28,
                      color: style.iconForeground,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}