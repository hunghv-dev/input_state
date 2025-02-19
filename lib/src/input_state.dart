import 'package:flutter/material.dart';
import 'input_formatter.dart';

/// An abstract class representing the state of an input field.
/// It manages the text input, validation, and formatting.
abstract class InputState with InputFormatter {
  /// The controller for the input field.
  final TextEditingController controller;

  /// A listener for text changes in the input field.
  late Function() _textListener = () {};

  /// Creates an [InputState] with an optional [TextEditingController].
  InputState({TextEditingController? controller})
      : controller = controller ?? TextEditingController();

  /// Adds a listener to the input field for text changes.
  void addListener({Function(String text)? text}) {
    _textListener = () => text?.call(controller.text);
    controller.addListener(_textListener);
  }

  /// Removes the text change listener from the input field.
  void removeListener() => controller.removeListener(_textListener);

  /// Updates the input field with new data, applying formatters.
  void input(data) {
    if (data == null || data.toString() == controller.text) return;
    TextEditingValue newValue =
        controller.value.copyWith(text: data.toString());
    for (final formatter in inputFormatters) {
      newValue = formatter.formatEditUpdate(controller.value, newValue);
    }
    controller.value = newValue;
  }

  /// Returns the current value of the input field.
  dynamic get value => controller.text;

  /// Returns the error message for the input field, if any.
  String? get error => null;

  /// Returns the error message when the input field is empty.
  String? get emptyError => null;

  /// Checks if the input field is empty.
  bool get isEmpty => controller.text.trim().isEmpty;

  /// Checks if the input field has an error.
  bool get isError => (isEmpty ? emptyError : error) != null;

  /// Checks if the input field is valid and not empty.
  bool get isDone => !isError && !isEmpty;

  /// Checks if the input field is either valid or empty.
  bool get isDoneOrEmpty => isDone || isEmpty;
}
