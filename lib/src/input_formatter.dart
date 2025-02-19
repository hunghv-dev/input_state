import 'package:flutter/services.dart';

/// A mixin that provides common text input formatters.
mixin InputFormatter {
  /// Returns a list of text input formatters.
  List<TextInputFormatter> get inputFormatters => [];

  /// A formatter that trims leading and trailing whitespace from the input.
  TextInputFormatter get trim => TextInputFormatter.withFunction(
        (oldValue, newValue) {
          final newText = newValue.text.trim();
          return TextEditingValue(
            text: newText,
            selection:
                TextSelection.collapsed(offset: oldValue.offsetWith(newText)),
          );
        },
      );

  /// A formatter that formats numbers with thousand separators.
  TextInputFormatter get thousand => TextInputFormatter.withFunction(
        (oldValue, newValue) {
          final newText = newValue.text
              .replaceAll(RegExp(r'\D'), '')
              .replaceAll(RegExp(r'^0+'), '')
              .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
          int offset = oldValue.offsetWith(newText);
          if (offset > 0 && newText[offset - 1] == ',') offset--;
          return TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: offset),
          );
        },
      );

  /// A formatter that limits the input length to a specified maximum.
  /// If used, it should always be placed at the end of the inputFormatters list.
  TextInputFormatter maxLength([int maxLength = 8]) =>
      TextInputFormatter.withFunction(
        (oldValue, newValue) =>
            newValue.text.length <= maxLength ? newValue : oldValue,
      );
}

/// Extension methods for [TextEditingValue].
extension TextEditingValueExt on TextEditingValue {
  /// Calculates the correct cursor offset after formatting.
  int offsetWith(String value) =>
      (value.length - (text.length - selection.end)).clamp(0, value.length);
}
