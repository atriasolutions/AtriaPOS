import 'dart:async';

import 'package:core/application/ports/trusted_clock.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

class PosClockDisplay extends StatefulWidget {
  const PosClockDisplay({super.key, required this.clock});

  final TrustedClock clock;

  @override
  State<PosClockDisplay> createState() => _PosClockDisplayState();
}

class _PosClockDisplayState extends State<PosClockDisplay> {
  Timer? _timer;
  late DateTime _instant;

  @override
  void initState() {
    super.initState();
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _tick() {
    setState(() => _instant = widget.clock.now());
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final time = formatChileTimeHm(_instant);
    final date = formatChileDate(_instant);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          time,
          key: const Key('pos_clock_label'),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
            height: 1.1,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          date,
          key: const Key('pos_clock_date_label'),
          style: textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
            height: 1.1,
          ),
        ),
      ],
    );
  }
}