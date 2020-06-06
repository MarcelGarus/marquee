library marquee;

import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';
import 'dart:async';
import 'package:flutter/material.dart';

/// A curve that represents the integral of another curve.
///
/// The constructor takes an other curve and calculates the integral. The
/// values of this curve are then being normalized onto the interval from 0 to
/// 1, but the integration value can always be obtained using the [interval]
/// property.
class _IntegralCurve extends Curve {
  /// Delta for integrating.
  static double delta = 0.01;

  _IntegralCurve._(this.original, this.integral, this._values);

  /// The original curve that was integrated.
  final Curve original;

  /// The integral value.
  final double integral;

  /// Cached cumulative values of the integral.
  final Map<double, double> _values;

  /// The constructor that takes the [original] curve.
  factory _IntegralCurve(Curve original) {
    double integral = 0.0;
    final values = Map<double, double>();

    for (double t = 0.0; t <= 1.0; t += delta) {
      integral += original.transform(t) * delta;
      values[t] = integral;
    }
    values[1.0] = integral;

    // Normalize.
    for (final double t in values.keys) values[t] /= integral;

    return _IntegralCurve._(original, integral, values);
  }

  /// Transforms a value to the normalized integrated value of the [original]
  /// curve.
  double transform(double t) {
    if (t < 0) return 0.0;

    for (final key in _values.keys) if (key > t) return _values[key];

    return 1.0;
  }
}

/// A widget that repeats text and automatically scrolls it infinitely.
///
/// ## Sample code
///
/// This is a minimalistic example:
///
/// ```dart
/// Marquee(
///   text: 'There once was a boy who told this story about a boy: "',
/// )
/// ```
///
/// And here's a piece of code that makes full use of the marquee's
/// customizability:
///
/// ```dart
/// Marquee(
///   text: 'Some sample text that takes some space.',
///   style: TextStyle(fontWeight: FontWeight.bold),
///   scrollAxis: Axis.horizontal,
///   blankSpace: 20.0,
///   velocity: 100.0,
///   pauseAfterRound: Duration(seconds: 1),
///   startPadding: 10.0,
///   accelerationDuration: Duration(seconds: 1),
///   accelerationCurve: Curves.linear,
///   decelerationDuration: Duration(milliseconds: 500),
///   decelerationCurve: Curves.easeOut,
/// )
/// ```
///
/// See also:
///
/// * [ListView.builder], where by returning the same widget to the builder
///   every time, a similar result can be achieved, just without the automatic
///   scrolling and manual scrolling enabled.
class Marquee extends StatefulWidget {
  Marquee({
    Key key,
    @required this.text,
    this.style,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.blankSpace = 0.0,
    this.velocity = 50.0,
    this.pauseAfterRound = Duration.zero,
    this.showFadingOnlyWhenScrolling = true,
    this.fadingEdgeStartFraction = 0.0,
    this.fadingEdgeEndFraction = 0.0,
    this.numberOfRounds,
    this.startPadding = 0.0,
    this.accelerationDuration = Duration.zero,
    Curve accelerationCurve = Curves.decelerate,
    this.decelerationDuration = Duration.zero,
    Curve decelerationCurve = Curves.decelerate,
  })  : assert(
            text != null,
            "The text cannot be null. If you don't want to display something, "
            "consider passing an empty string instead."),
        assert(scrollAxis != null),
        assert(crossAxisAlignment != null),
        assert(
            blankSpace != null,
            "The blankSpace cannot be null. If you don't want any blank space, "
            "consider setting it to zero instead."),
        assert(!blankSpace.isNaN),
        assert(blankSpace >= 0, "The blankSpace needs to be positive or zero."),
        assert(blankSpace.isFinite),
        assert(velocity != null),
        assert(!velocity.isNaN),
        assert(velocity != 0.0, "The velocity cannot be zero."),
        assert(velocity.isFinite),
        assert(
            pauseAfterRound != null,
            "The pauseAfterRound cannot be null. If you don't want to pause, "
            "consider setting it to Duration.zero instead."),
        assert(
            pauseAfterRound >= Duration.zero,
            "The pauseAfterRound cannot be negative as time travel isn't "
            "invented yet."),
        assert(fadingEdgeStartFraction >= 0 && fadingEdgeStartFraction <= 1,
            "The fadingEdgeGradientFractionOnStart value should be between 0 and 1, inclusive"),
        assert(fadingEdgeEndFraction >= 0 && fadingEdgeEndFraction <= 1,
            "The fadingEdgeGradientFractionOnEnd value should be between 0 and 1, inclusive"),
        assert(
            startPadding != null,
            "The start padding cannot be null. If you don't want any "
            "startPadding, consider setting it to zero."),
        assert(numberOfRounds == null || numberOfRounds > 0),
        assert(accelerationDuration != null),
        assert(
            accelerationDuration >= Duration.zero,
            "The accelerationDuration cannot be negative as time travel isn't "
            "invented yet."),
        assert(
            accelerationCurve != null || accelerationDuration != Duration.zero,
            "Even if the accelerationDuration is zero, you still need to "
            "provide an accelerationCurve. Sorry about that."),
        assert(accelerationCurve != null),
        assert(decelerationDuration != null),
        assert(
            decelerationDuration >= Duration.zero,
            "The decelerationDuration must be positive or zero as time travel "
            "isn't invented yet."),
        assert(
            decelerationCurve != null || decelerationDuration != Duration.zero,
            "Even if the decelerationDuration is zero, you still need to "
            "provide an decelerationCurve. Sorry about that."),
        assert(decelerationCurve != null),
        this.accelerationCurve = _IntegralCurve(accelerationCurve),
        this.decelerationCurve = _IntegralCurve(decelerationCurve),
        super(key: key);

  /// The text to be displayed.
  ///
  /// See also:
  ///
  /// * [style] to style the text.
  final String text;

  /// The style of the text to be displayed.
  ///
  /// ## Sample code
  ///
  /// This marquee has a bold text:
  ///
  /// ```dart
  /// Marquee(
  ///   text: 'This is some bold text.',
  ///   style: TextStyle(weight: FontWeight.bold)
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [text] to provide the text itself.
  final TextStyle style;

  /// The scroll axis.
  ///
  /// If set to [Axis.horizontal], the default scrolling direction is to the
  /// right.
  /// If set to [Axis.vertical], the default scrolling direction is to the
  /// bottom.
  ///
  /// ## Sample code
  ///
  /// This marquee scrolls vertically:
  ///
  /// ```dart
  /// Marquee(
  ///   scrollAxis: Axis.vertical,
  ///   text: "Look what's below this:",
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * The sign of [velocity] to define the concrete scroll direction on this
  ///   axis.
  final Axis scrollAxis;

  /// The alignment along the cross axis.
  ///
  /// # Sample code
  ///
  /// ```-dart
  /// Marquee(
  ///   crossAxisAlignment: CrossAxisAlignment.start,
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [scrollAxis] for setting the primary axis.
  final CrossAxisAlignment crossAxisAlignment;

  /// The extend of blank space to display between instances of the text.
  ///
  /// ## Sample code
  ///
  /// In this example, there's 300 density pixels between the text instances:
  ///
  /// ```dart
  /// Marquee(
  ///   blankSpace: 300.0,
  ///   child: 'Wait for it...',
  /// )
  /// ```
  final double blankSpace;

  /// The scrolling velocity in pixels per second.
  ///
  /// If a negative velocity is provided, the marquee scrolls in the reverse
  /// direction (to the right for horizontal marquees and to the top for
  /// vertical ones).
  ///
  /// ## Sample code
  ///
  /// This marquee scrolls backwards with 1000 pixels per second:
  ///
  /// ```dart
  /// Marquee(
  ///   velocity: -1000.0,
  ///   text: 'Gotta go fast in the reverse direction',
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [scrollAxis] to change the axis in which the scrolling takes place.
  final double velocity;

  /// After each round, a pause of this duration occurs.
  ///
  /// ## Sample code
  ///
  /// After every round, this marquee pauses for one second.
  ///
  /// ```dart
  /// Marquee(
  ///   pauseAfterRound: Duration(seconds: 1),
  ///   text: 'Pausing for some time after every round.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [accelerationDuration] and [decelerationDuration] to make the
  ///   transitions between moving and paused state smooth.
  /// * [accelerationCurve] and [decelerationCurve] to have more control about
  ///   how the transition between moving and pausing state occur.
  final Duration pauseAfterRound;

  /// When the text scrolled around [numberOfRounds] times, it will stop scrolling
  /// `null` indicates there is no limit
  ///
  /// ## Sample code
  ///
  /// This marquee stops after 3 rounds
  ///
  /// ```dart
  /// Marquee(
  ///   numberOfRounds:3,
  ///   text: 'Stopping after three rounds.'
  /// )
  /// ```
  final int numberOfRounds;

  /// Whether the fading edge should only appear while the text is
  /// scrolling.
  ///
  /// ## Sample code
  ///
  /// This marquee will only show the fade while scrolling.
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final bool showFadingOnlyWhenScrolling;

  /// The fraction of the [Marquee] that will be faded on the left or top.
  /// By default, there won't be any fading.
  ///
  /// ## Sample code
  ///
  /// This marquee fades the edges while scrolling
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final double fadingEdgeStartFraction;

  /// The fraction of the [Marquee] that will be faded on the right or down.
  /// By default, there won't be any fading.
  ///
  /// ## Sample code
  ///
  /// This marquee fades the edges while scrolling
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final double fadingEdgeEndFraction;

  /// A padding for the resting position.
  ///
  /// In between rounds, the marquee stops at this position. This parameter is
  /// especially useful if the marquee pauses after rounds and some other
  /// widgets are stacked on top of the marquee and block the sides, like
  /// fading gradients.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// Marquee(
  ///   startPadding: 20.0,
  ///   pauseAfterRound: Duration(seconds: 1),
  ///   text: "During pausing, this text is shifted 20 pixel to the right."
  /// )
  /// ```
  final double startPadding;

  /// How long the acceleration takes.
  ///
  /// At the start of each round, the scrolling speed gains momentum for this
  /// duration. This parameter is only useful if you embrace a pause after
  /// every round.
  ///
  /// ## Sample code
  ///
  /// A marquee that slowly accelerates in two seconds.
  ///
  /// ```dart
  /// Marquee(
  ///   accelerationDuration: Duration(seconds: 2),
  ///   text: 'Gaining momentum in two seconds.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [accelerationCurve] to define a custom curve for accelerating.
  /// * [decelerationDuration], the equivalent for decelerating.
  final Duration accelerationDuration;

  /// The acceleration at the start of each round.
  ///
  /// At the start of each round, the acceleration is defined by this curve
  /// where 0.0 stands for not moving and 1.0 for the target [velocity].
  /// Notice that it's useless to set the curve if you leave the
  /// [accelerationDuration] at the default of [Duration.zero].
  /// Also notice that you don't provide the scroll positions, but the actual
  /// velocity, so this curve gets integrated.
  ///
  /// ## Sample code
  ///
  /// A marquee that accelerates with a custom curve.
  ///
  /// ```dart
  /// Marquee(
  ///   accelerationDuration: Duration(seconds: 1),
  ///   accelerationCurve: Curves.easeInOut,
  ///   text: 'Accelerating with a custom curve.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [accelerationDuration] to change the duration of the acceleration.
  /// * [decelerationCurve], the equivalent for decelerating.
  final _IntegralCurve accelerationCurve;

  /// How long the deceleration takes.
  ///
  /// At the end of each round, the scrolling speed gradually comes to a
  /// halt in this duration. This parameter is only useful if you embrace a
  /// pause after every round.
  ///
  /// ## Sample code
  ///
  /// A marquee that gradually comes to a halt in two seconds.
  ///
  /// ```dart
  /// Marquee(
  ///   decelerationDuration: Duration(seconds: 2),
  ///   text: 'Gradually coming to a halt in two seconds.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [decelerationCurve] to define a custom curve for accelerating.
  /// * [accelerationDuration], the equivalent for decelerating.
  final Duration decelerationDuration;

  /// The deceleration at the end of each round.
  ///
  /// At the end of each round, the deceleration is defined by this curve where
  /// 0.0 stands for not moving and 1.0 for the target [velocity].
  /// Notice that it's useless to set this curve if you leave the
  /// [accelerationDuration] at the default of [Duration.zero].
  /// Also notice that you don't provide the scroll position, but the actual
  /// velocity, so this curve gets integrated.
  ///
  /// ## Sample code
  ///
  /// A marquee that decelerates with a custom curve.
  ///
  /// ```dart
  /// Marquee(
  ///   decelerationDuration: Duration(seconds: 1),
  ///   decelerationCurve: Curves.easeInOut,
  ///   text: 'Decelerating with a custom curve.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [decelerationDuration] to change the duration of the acceleration.
  /// * [accelerationCurve], the equivalent for decelerating.
  final _IntegralCurve decelerationCurve;

  @override
  State<StatefulWidget> createState() => _MarqueeState();

  bool equals(Object other) {
    return other is Marquee &&
        text == other.text &&
        style == other.style &&
        scrollAxis == other.scrollAxis &&
        blankSpace == other.blankSpace &&
        velocity == other.velocity &&
        startPadding == other.startPadding &&
        pauseAfterRound == other.pauseAfterRound &&
        numberOfRounds == other.numberOfRounds &&
        accelerationDuration == other.accelerationDuration &&
        accelerationCurve == other.accelerationCurve &&
        decelerationDuration == other.decelerationDuration &&
        decelerationCurve == other.decelerationCurve;
  }
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  /// The controller for the scrolling behavior.
  final ScrollController _controller = ScrollController();

  // The scroll positions at various scrolling phases.
  double _startPosition; // At the start, before accelerating.
  double _accelerationTarget; // After accelerating, before moving linearly.
  double _linearTarget; // After moving linearly, before decelerating.
  double _decelerationTarget; // After decelerating.

  // The durations of various scrolling phases.
  Duration _totalDuration;

  Duration get _accelerationDuration => widget.accelerationDuration;
  Duration _linearDuration; // The duration of linearly scrolling.
  Duration get _decelerationDuration => widget.decelerationDuration;

  /// A timer that is fired at the start of each round.
  bool _running = false;
  bool _isOnPause = false;
  int _roundCounter = 0;
  bool get isDone => widget.numberOfRounds == null
      ? false
      : widget.numberOfRounds == _roundCounter;
  bool get showFading =>
      !widget.showFadingOnlyWhenScrolling ? true : !_isOnPause;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_running) {
        _running = true;
        Future.doWhile(_scroll);
      }
    });
  }

  Future<bool> _scroll() async {
    await _makeRoundTrip();
    return _running && !isDone;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If any parameters of the widget changed, recalculate the values and start
    // scrolling from the start, just as if the widget was created brand-new.
    // if (widget != oldWidget) _initialize();
  }

  @override
  void dispose() {
    _running = false;
    super.dispose();
  }

  // Calculates all necessary values for animating, then starts the animation.
  void _initialize(BuildContext context) {
    //print('Initializing');

    // Calculate lengths (amount of pixels that each phase needs).
    final totalLength = _getTextWidth(context) + widget.blankSpace;
    final accelerationLength = widget.accelerationCurve.integral *
        widget.velocity *
        _accelerationDuration.inMilliseconds /
        1000.0;
    final decelerationLength = widget.decelerationCurve.integral *
        widget.velocity *
        _decelerationDuration.inMilliseconds /
        1000.0;
    final linearLength =
        (totalLength - accelerationLength.abs() - decelerationLength.abs()) *
            (widget.velocity > 0 ? 1 : -1);

    // Calculate scroll positions at various scrolling phases.
    _startPosition = 2 * totalLength - widget.startPadding;
    _accelerationTarget = _startPosition + accelerationLength;
    _linearTarget = _accelerationTarget + linearLength;
    _decelerationTarget = _linearTarget + decelerationLength;

    // Calculate durations for the phases.
    _totalDuration = _accelerationDuration +
        _decelerationDuration +
        Duration(milliseconds: (linearLength / widget.velocity * 1000).toInt());
    _linearDuration =
        _totalDuration - _accelerationDuration - _decelerationDuration;

    assert(
        _totalDuration > Duration.zero,
        "With the given values, the total duration for one round would be "
        "negative. As time travel isn't invented yet, this shouldn't happen.");
    assert(
        _linearDuration >= Duration.zero,
        "Acceleration and deceleration phase overlap. To fix this, try a "
        "combination of these approaches:\n"
        "* Make the text longer, so there's more room to animate within.\n"
        "* Shorten the accelerationDuration or decelerationDuration.\n"
        "* Decrease the velocity, so the duration to animate within is longer.\n");
  }

  /// Causes the controller to scroll one round.
  Future<void> _makeRoundTrip() async {
    // Reset the controller, then accelerate, move linearly and decelerate.
    _controller.jumpTo(_startPosition);
    if (!_running) return;

    await _accelerate();
    if (!_running) return;

    await _moveLinearly();
    if (!_running) return;

    await _decelerate();

    _roundCounter++;

    if (!_running || !mounted) return;

    if (widget.pauseAfterRound > Duration.zero) {
      setState(() => _isOnPause = true);

      await Future.delayed(widget.pauseAfterRound);

      if (!mounted || isDone) return;
      setState(() => _isOnPause = false);
    }
  }

  // Methods that animate the controller.
  Future<void> _accelerate() async => await _animateTo(
      _accelerationTarget, _accelerationDuration, widget.accelerationCurve);

  Future<void> _moveLinearly() async =>
      await _animateTo(_linearTarget, _linearDuration, Curves.linear);

  Future<void> _decelerate() async => await _animateTo(_decelerationTarget,
      _decelerationDuration, widget.decelerationCurve.flipped);

  /// Helping method that either animates to the given target position or jumps
  /// right to it if the duration is Duration.zero.
  Future<void> _animateTo(double target, Duration duration, Curve curve) async {
    if (duration > Duration.zero) {
      await _controller.animateTo(target, duration: duration, curve: curve);
    } else {
      _controller.jumpTo(target);
    }
  }

  /// Returns the width of the text.
  double _getTextWidth(BuildContext context) {
    final span = TextSpan(text: widget.text, style: widget.style);

    final constraints = BoxConstraints(maxWidth: double.infinity);

    final richTextWidget = Text.rich(span).build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);

    final boxes = renderObject.getBoxesForSelection(TextSelection(
      baseOffset: 0,
      extentOffset: TextSpan(text: widget.text).toPlainText().length,
    ));

    return boxes.last.right;
  }

  @override
  Widget build(BuildContext context) {
    _initialize(context);
    bool isHorizontal = widget.scrollAxis == Axis.horizontal;

    Alignment alignment;

    switch (widget.crossAxisAlignment) {
      case CrossAxisAlignment.start:
        alignment = isHorizontal ? Alignment.topCenter : Alignment.centerLeft;
        break;
      case CrossAxisAlignment.end:
        alignment =
            isHorizontal ? Alignment.bottomCenter : Alignment.centerRight;
        break;
      case CrossAxisAlignment.center:
        alignment = Alignment.center;
        break;
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        alignment = null;
        break;
    }
    return FadingEdgeScrollView.fromScrollView(
      gradientFractionOnStart:
          !showFading ? 0.0 : widget.fadingEdgeStartFraction,
      gradientFractionOnEnd: !showFading ? 0.0 : widget.fadingEdgeEndFraction,
      shouldDisposeScrollController: false,
      child: ListView.builder(
        controller: _controller,
        scrollDirection: widget.scrollAxis,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) {
          final text = i.isEven
              ? Text(widget.text, style: widget.style)
              : _buildBlankSpace();
          return alignment == null
              ? text
              : Align(alignment: alignment, child: text);
        },
      ),
    );
  }

  /// Builds the blank space between children.
  Widget _buildBlankSpace() {
    return SizedBox(
      width: widget.scrollAxis == Axis.horizontal ? widget.blankSpace : null,
      height: widget.scrollAxis == Axis.vertical ? widget.blankSpace : null,
    );
  }
}
