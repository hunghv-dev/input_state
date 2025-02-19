import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:input_state/src/input_error.dart';
import 'package:input_state/src/input_state.dart';

class _TestInputState extends InputState {
  @override
  String? get error => controller.text == 'error' ? 'Error detected' : null;
}

void main() {
  late InputState inputState;

  setUp(() => inputState = _TestInputState());

  testWidgets('InputError displays error message', (WidgetTester tester) async {
    inputState.input('error');
    await tester.pumpWidget(MaterialApp(home: InputError(state: inputState)));

    expect(find.text('Error detected'), findsOneWidget);
  });

  testWidgets('InputError does not show when no error',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: InputError(state: inputState)));

    expect(find.text('Error detected'), findsNothing);
  });

  testWidgets('Shake animation triggers when error appears',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        MaterialApp(home: InputError(state: inputState, shake: true)));

    inputState.input('error');
    await tester.pump();

    expect(find.byType(InputError), findsOneWidget);
  });
}
