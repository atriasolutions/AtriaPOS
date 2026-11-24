import 'package:core/domain/domain.dart';
import 'package:flutter/services.dart';

/// Sustituye ñ/Ñ por n/N mientras el usuario escribe (SLICE-78).
class LatinNWithoutEnyeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final next = CredentialPolicy.normalizeUsername(newValue.text);
    if (next == newValue.text) return newValue;
    return TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );
  }
}

/// RUT chileno sin puntos, con guión antes del dígito verificador.
class RutChileEntryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final formatted = RutChile.formatAsUserTypes(newValue.text);
    if (formatted == newValue.text) return newValue;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}