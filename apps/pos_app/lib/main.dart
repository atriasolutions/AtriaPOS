import 'dart:io';

import 'package:core/app_database_paths.dart';
import 'package:core/atria_pos_core.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_shell.dart';
import 'di/pos_composition.dart';
import 'theme/atria_theme.dart';
import 'widgets/pos_clock_overlay.dart';

PosComposition? _composition;

/// Punto de entrada. Pase [testComposition] en integration_test.
Future<void> main({PosComposition? testComposition}) async {
  WidgetsFlutterBinding.ensureInitialized();
  _composition = testComposition ?? await _openDefaultComposition();
  if (testComposition == null) {
    await _composition!.bootstrapClock();
  }
  runApp(
    PosApp(
      composition: _composition!,
      showClockOverlay: testComposition == null,
    ),
  );
}

Future<PosComposition> _openDefaultComposition() async {
  final dir = await getApplicationSupportDirectory();
  final dbPath = resolveSqlitePath(dir.path);
  return PosComposition.file(dbPath);
}

class PosApp extends StatelessWidget {
  const PosApp({
    super.key,
    required this.composition,
    this.showClockOverlay = true,
  });

  final PosComposition composition;
  final bool showClockOverlay;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: AtriaTheme.light,
      home: showClockOverlay
          ? PosClockOverlay(
              clock: composition.trustedClock,
              child: AppShell(composition: composition),
            )
          : AppShell(composition: composition),
    );
  }
}

/// Cierra DB al terminar tests (integration_test).
Future<void> disposePosApp() async {
  await _composition?.close();
  _composition = null;
}

/// Ruta temporal para integration_test en desktop.
Future<PosComposition> openTestComposition() async {
  final tempDir = await Directory.systemTemp.createTemp('atria_pos_test_');
  final dbPath = p.join(tempDir.path, 'test.sqlite');
  return PosComposition.file(dbPath);
}