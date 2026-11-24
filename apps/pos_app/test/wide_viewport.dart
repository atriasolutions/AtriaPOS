import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';

void setWideSaleViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(1280, 900);
  tester.view.devicePixelRatio = 1.0;
}