import 'package:core/api/api.dart';
import 'package:flutter/material.dart';

import '../di/pos_composition.dart';

/// Maneja `SESION_EXPIRADA` de forma centralizada (SLICE-82).
bool handleApiFailure(
  BuildContext context,
  PosComposition composition,
  ApiErrorBody error,
) {
  if (error.code == 'SESION_EXPIRADA') {
    composition.notifySessionExpired();
    return true;
  }
  return false;
}