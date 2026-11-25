import 'package:core/domain/domain.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';
import 'companion_lan_status_presenter.dart';

class CompanionLanStatusChip extends StatelessWidget {
  const CompanionLanStatusChip({
    super.key,
    required this.composition,
  });

  final PosComposition composition;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CompanionLanStatus>(
      stream: composition.companionLanStatusStream(),
      builder: (context, snapshot) {
        final status = snapshot.data;
        if (status == null) {
          return const SizedBox.shrink();
        }
        if (status.phase == CompanionLanPhase.none) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Chip(
              key: const Key('companion_lan_status_chip'),
              avatar: Icon(
                status.phase == CompanionLanPhase.live
                    ? Icons.phone_android
                    : Icons.qr_code_2,
              ),
              label: Text(companionLanStatusLabel(status)),
            ),
          ),
        );
      },
    );
  }
}