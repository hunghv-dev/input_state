import 'dart:math';
import 'package:flutter/material.dart';
import 'input_state.dart';

/// A widget that displays an error message for an input field.
/// It supports optional shaking animation and custom error labels.
/// The error message is determined by the [InputState] provided.
class InputError extends StatefulWidget {
  /// The state of the input field, which determines the error message.
  final InputState state;

  /// Whether to apply a shaking animation to the error message.
  final bool shake;

  /// An optional custom widget builder for the error label.
  final Widget Function(String error)? errorLabel;

  /// Creates an [InputError] widget.
  const InputError(
      {super.key, required this.state, this.shake = false, this.errorLabel});

  @override
  State<InputError> createState() => _InputErrorState();
}

/// The state class for [InputError], managing animations and visibility.
class _InputErrorState extends State<InputError>
    with SingleTickerProviderStateMixin {
  late final GlobalKey _errorKey = GlobalKey();

  /// Ensures the error message is visible by scrolling it into view.
  void _visible() => WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          final context = _errorKey.currentContext;
          if (context == null) return;
          Scrollable.ensureVisible(
            context,
            curve: Curves.ease,
            alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
          );
        },
      );

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
      valueListenable: widget.state.controller,
      builder: (_, __, ___) {
        final errorMessage = (widget.state.isEmpty
                ? widget.state.emptyError
                : widget.state.error) ??
            '';
        final error =
            widget.errorLabel?.call(errorMessage) ?? Text(errorMessage);
        _visible();
        return widget.state.isError
            ? _Slide(
                key: _errorKey,
                child: widget.shake
                    ? _Shake(text: widget.state.controller.text, child: error)
                    : error,
              )
            : const SizedBox.shrink();
      });
}

/// A widget that animates the appearance of its child with a slide and fade effect.
class _Slide extends StatefulWidget {
  final Widget child;

  const _Slide({super.key, required this.child});

  @override
  State<_Slide> createState() => _SlideState();
}

/// The state class for [_Slide], managing the slide and fade animation.
class _SlideState extends State<_Slide> with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 165),
    )..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: Tween<double>(begin: 0.0, end: 1).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeIn,
          ),
        ),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.2),
            end: Offset.zero,
          ).animate(controller),
          child: widget.child,
        ),
      );
}

/// A widget that applies a shaking animation to its child.
class _Shake extends StatefulWidget {
  final String? text;
  final Widget child;

  const _Shake({required this.child, this.text});

  @override
  State<_Shake> createState() => _ShakeState();
}

/// The state class for [_Shake], managing the shaking animation.
class _ShakeState extends State<_Shake> with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 300),
  );

  @override
  void didUpdateWidget(oldWidget) {
    if (widget.text == null || widget.text != oldWidget.text) {
      controller.forward().whenComplete(controller.reset);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.005, 0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: const _ShakeCurve(),
          ),
        ),
        child: SizedBox(width: double.infinity, child: widget.child),
      );
}

/// A custom curve for the shaking animation.
class _ShakeCurve extends Curve {
  const _ShakeCurve();

  @override
  double transformInternal(double t) => sin(4 * pi * t);
}
