import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// SC-124-02 — reglas ProGuard mínimas para ML Kit y mobile_scanner en release.
void main() {
  test('proguard-rules.pro incluye keeps para ML Kit y mobile_scanner', () {
    final file = File('android/app/proguard-rules.pro');
    expect(
      file.existsSync(),
      isTrue,
      reason: 'Debe existir android/app/proguard-rules.pro',
    );
    final text = file.readAsStringSync();
    expect(text, contains('com.google.mlkit.**'));
    expect(text, contains('dev.steenbakker.mobile_scanner.**'));
    expect(text, contains('com.google.android.libraries.barhopper.**'));
  });
}