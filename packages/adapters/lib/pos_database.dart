import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'src/database.dart';

/// Abre [AppDatabase] sobre archivo SQLite (app productiva / integration_test).
AppDatabase openPosDatabaseFile(String filePath) {
  final file = File(filePath);
  file.parent.createSync(recursive: true);
  return AppDatabase(NativeDatabase(file));
}

/// Base en memoria (widget tests, demos).
AppDatabase openPosDatabaseMemory() => AppDatabase(NativeDatabase.memory());

/// Cierra conexiones nativas (llamar al cerrar la app o en tearDown de tests).
Future<void> closePosDatabase(AppDatabase db) async {
  final executor = db.executor;
  await db.close();
  if (executor is NativeDatabase) {
    executor.close();
  }
}