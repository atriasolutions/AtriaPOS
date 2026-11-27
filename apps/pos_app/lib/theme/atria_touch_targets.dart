import 'package:flutter/material.dart';

/// Altura mínima de controles táctiles en operación (mostrador).
const double kMinTouchHeight = 56;

EdgeInsets touchPadding({double horizontal = 16, double vertical = 12}) {
  return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
}

ButtonStyle touchPrimaryButtonStyle(ThemeData theme) {
  return FilledButton.styleFrom(
    minimumSize: const Size.fromHeight(kMinTouchHeight),
    padding: touchPadding(horizontal: 20),
  );
}

InputDecoration touchTextFieldDecoration({
  required String labelText,
  String? hintText,
}) {
  return InputDecoration(
    labelText: labelText,
    hintText: hintText,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    border: const OutlineInputBorder(),
    isDense: false,
  );
}