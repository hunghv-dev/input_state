import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:input_state/src/input_formatter.dart';

class _TestFormatter with InputFormatter {}

void main() {
  late InputFormatter formatter;

  setUp(() => formatter = _TestFormatter());

  test('Trim formatter should remove leading and trailing spaces', () {
    const oldValue = TextEditingValue(
        text: '  hello  ', selection: TextSelection.collapsed(offset: 9));
    final newValue = formatter.trim.formatEditUpdate(oldValue, oldValue);

    expect(newValue.text, 'hello');
    expect(newValue.selection.baseOffset, 5);
  });

  test('Thousand formatter should format numbers correctly', () {
    const oldValue = TextEditingValue(
        text: '1234', selection: TextSelection.collapsed(offset: 4));
    final newValue = formatter.thousand.formatEditUpdate(oldValue, oldValue);

    expect(newValue.text, '1,234');
  });

  test('Max length formatter should enforce max length', () {
    final maxLengthFormatter = formatter.maxLength(5);
    const oldValue = TextEditingValue(
        text: '12345', selection: TextSelection.collapsed(offset: 5));
    final newValue = maxLengthFormatter.formatEditUpdate(
        oldValue, const TextEditingValue(text: '123456'));

    expect(newValue.text, '12345');
  });
}
