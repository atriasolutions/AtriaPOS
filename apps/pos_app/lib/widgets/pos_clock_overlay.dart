import 'dart:async';

import 'package:core/application/ports/trusted_clock.dart';
import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

class PosClockOverlay extends StatefulWidget {
  const PosClockOverlay({
    super.key,
    required this.clock,
    required this.child,
  });

  final TrustedClock clock;
  final Widget child;

  @override
  State<PosClockOverlay> createState() => _PosClockOverlayState();
}

class _PosClockOverlayState extends State<PosClockOverlay> {
  Timer? _timer;
  String _label = '';

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
    final instant = widget.clock.now();
    final degraded = widget.clock.isDegraded;
    final formatted = formatChileDateTime(instant);
    setState(() {
      _label = degraded ? '$formatted · reloj local' : '$formatted · SHOA';
    });
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + 4;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          top: top,
          right: 8,
          child: IgnorePointer(
            child: Material(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  _label,
                  key: const Key('pos_clock_label'),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}