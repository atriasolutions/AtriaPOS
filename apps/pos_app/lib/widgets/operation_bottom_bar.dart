import 'package:flutter/material.dart';

import '../theme/atria_touch_targets.dart';

class OperationBottomBar extends StatelessWidget {
  const OperationBottomBar({
    super.key,
    required this.primaryKey,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryBusy = false,
    this.secondary,
    this.disabledHint,
  });

  final Key primaryKey;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryBusy;
  final Widget? secondary;
  final String? disabledHint;

  @override
  Widget build(BuildContext context) {
  final enabled = onPrimary != null && !primaryBusy;
    return Material(
      elevation: 8,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!enabled && disabledHint != null) ...[
              Semantics(
                liveRegion: true,
                child: Text(
                  disabledHint!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (secondary != null) ...[
              secondary!,
              const SizedBox(height: 8),
            ],
            Semantics(
              button: true,
              enabled: enabled,
              label: primaryLabel,
              child: FilledButton(
                key: primaryKey,
                onPressed: onPrimary,
                style: touchPrimaryButtonStyle(Theme.of(context)),
                child: primaryBusy
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(primaryLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}