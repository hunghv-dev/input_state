A library that adds basic functionalities for input state

<div style="text-align: center;">  
  <img src="https://raw.githubusercontent.com/hunghv-dev/input_state/develop/doc/input_state.png" 
       alt="input_state.png" 
       width="200" 
       height="auto" />  
</div>

## Getting started

To install, add it to your `pubspec.yaml` file:

```
dependencies:
    input_state:
```

To import it:

```dart
import 'package:input_state/input_state.dart';
```

## Usage

Initialize the state with configurable properties:

```dart
class State extends InputState {
  @override
  List<TextInputFormatter> get inputFormatters => [thousand];

  @override
  String? get error => value.length > 7 ? 'Error' : null;
}
```

Implementation in main():

```dart
void main() {
  final inputState = State();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: inputState.controller,
                      inputFormatters: inputState.inputFormatters,
                    ),
                    const SizedBox(height: 10.0),
                    InputError(state: inputState, shake: true),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['10,000', '100,000', '1,000,000']
                    .map((e) =>
                    ElevatedButton(
                        onPressed: () => inputState.input(e), child: Text(e)))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    ),
  ));
}
```