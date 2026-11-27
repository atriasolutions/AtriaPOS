import 'package:core/application/ports/trusted_clock.dart';
import 'package:core/atria_pos_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pos_clock_display.dart';

class PosStatusStrip extends StatelessWidget {
  const PosStatusStrip({
    super.key,
    required this.clock,
    required this.child,
    this.showClock = true,
  });

  final TrustedClock clock;
  final Widget child;
  final bool showClock;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trailingInset = kDebugMode ? 72.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColoredBox(
          color: scheme.surface,
          child: SafeArea(
            bottom: false,
            child: DecoratedBox(
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
                  child: Row(
                    children: [
                      Text(
                        kAppName,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const Spacer(),
                      if (showClock) PosClockDisplay(clock: clock),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}