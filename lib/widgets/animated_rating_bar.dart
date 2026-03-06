import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedRatingBar extends StatefulWidget {
  /// [AnimatedRatingBar] can be used for rating which enhaces User Experince
  ///
  /// by displaying beautiful animation like glows and sparks.
  ///
  /// Exmple:
  /// ```dart
  /// return AnimatedRatingBar(
  ///          activeFillColor: Theme.of(context).colorScheme.inversePrimary,
  ///          strokeColor: Theme.of(context).colorScheme.inversePrimary,
  ///          initialRating: 0,
  ///          height: 60,
  ///          width: MediaQuery.of(context).size.width,
  ///          animationColor: Theme.of(context).colorScheme.inversePrimary,
  ///          onRatingUpdate: (rating) {
  ///            debugPrint(rating.toString());
  ///          },
  ///        );
  /// ```
  const AnimatedRatingBar(
      {super.key,
      this.initialRating = 0.0,
      this.height,
      this.width,
      this.activeFillColor,
      this.strokeColor,
      required this.onRatingUpdate,
      this.animationColor});

  /// This sets Initial Rating of the Animated Rating Bar
  ///
  /// If not provided, by default it will start from 0.0
  final double? initialRating;

  /// Holds the height of the widget. You can customise it
  ///
  /// accoring to your requirements.
  final double? height;

  /// Holds the width of the widget. You can customise it
  ///
  /// accoring to your requirements.
  final double? width;

  /// Fills color on inner layer of icon except stroke.
  ///
  /// Note: Per-component color customisation is not supported in Rive >=0.14.
  final Color? activeFillColor;

  /// You can even modify stroke color using this property.
  ///
  /// Note: Per-component color customisation is not supported in Rive >=0.14.
  final Color? strokeColor;

  /// Animation color holds both glow and sparks color
  ///
  /// Note: Per-component color customisation is not supported in Rive >=0.14.
  final Color? animationColor;

  /// This holds double value on updation of the rating.
  final ValueChanged<double> onRatingUpdate;

  @override
  State<AnimatedRatingBar> createState() => _AnimatedRatingBarState();
}

class _AnimatedRatingBarState extends State<AnimatedRatingBar> {
  late final FileLoader _fileLoader;
  RiveWidgetController? _controller;
  // ignore: deprecated_member_use
  NumberInput? _ratingInput;
  double _lastRatingValue = 0.0;

  @override
  void initState() {
    super.initState();
    _fileLoader = FileLoader.fromAsset(
      "packages/animated_rating_bar/assets/new_rating_animation.riv",
      riveFactory: Factory.flutter,
    );
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerChanged);
    _fileLoader.dispose();
    super.dispose();
  }

  void _onRiveLoaded(RiveLoaded state) {
    _controller = state.controller;
    // ignore: deprecated_member_use
    _ratingInput = _controller!.stateMachine.number('Rating');
    _ratingInput?.value = widget.initialRating ?? 1;
    _controller!.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    final newRating = _ratingInput?.value ?? 0.0;
    if (newRating != _lastRatingValue) {
      _lastRatingValue = newRating;
      widget.onRatingUpdate(newRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 40,
      width: widget.width ?? 140,
      child: RiveWidgetBuilder(
        fileLoader: _fileLoader,
        stateMachineSelector: StateMachineSelector.byName("State Machine 1"),
        onLoaded: _onRiveLoaded,
        builder: (context, state) => switch (state) {
          RiveLoading() => const SizedBox.shrink(),
          RiveFailed() => const SizedBox.shrink(),
          RiveLoaded() => RiveWidget(
              controller: state.controller,
              fit: Fit.contain,
            ),
        },
      ),
    );
  }
}
