import 'package:flutter_test/flutter_test.dart';
import 'package:input_state/src/input_state.dart';

class TestInputState extends InputState {
  TestInputState({super.controller});

  @override
  String? get error => controller.text == 'error' ? 'Error detected' : null;
}

void main() {
  late TestInputState inputState;

  setUp(() => inputState = TestInputState());

  test('InputState should update value correctly', () {
    inputState.input('Test');
    expect(inputState.value, 'Test');
  });

  test('isEmpty should return true when text is empty', () {
    expect(inputState.isEmpty, true);
  });

  test('isError should return true when text triggers error', () {
    inputState.input('error');
    expect(inputState.isError, true);
  });

  test('Listener should trigger correctly', () {
    String? capturedText;
    inputState.addListener(text: (text) => capturedText = text);

    inputState.input('Hello');
    expect(capturedText, 'Hello');

    inputState.removeListener();
  });
}
