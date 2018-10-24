library marquee;

import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';

class _IntegralCurve extends Curve {
  _IntegralCurve(this.original) {
    double integral = 0.0;
    for (double t = 0.0; t <= 1.0; t += 0.01) {
      integral += original.transform(t) * 0.01;
      cache[t] = integral;
    }
    cache[1.0] = integral;
  }
  
  final Curve original;
  final cache = Map<double, double>();

  double transform(double t) {
    for (final key in cache.keys)
      if (key > t)
        return cache[key];
    return cache[1.0];
  }
}

/// A widget that scroll its child infinitely.
///
/// It repeats the given child infinitely and automatically scrolls in the
/// direction of the specified [scrollAxis] with the given [velocity].
///
/// Between children, it leaves the given [blankSpace].
///
/// ## Sample code
///
/// This snippet scrolls the text infinitely in a horizontal direction:
///
/// ```dart
/// Marquee(
///   velocity: 20.0,
///   child: Text('There once was a boy who told this story about a boy: "'),
/// )
/// ```
///
/// See also:
///
/// * [ListView.builder], where by returning the same widget to the builder
///   every time, a similar result can be achieved without the automatic
///   scrolling and user's scrolling enabled.
class Marquee extends StatefulWidget {
  Marquee({
    Key key,
    @required this.text,
    this.style,
    this.scrollAxis = Axis.horizontal,
    this.blankSpace = 0.0,
    this.velocity = 50.0,
    this.pauseOnRoundTrip = true,
    this.accelerationDuration = const Duration(seconds: 1),
    this.accelerationCurve = Curves.easeInOut,
    this.decelerationDuration = const Duration(seconds: 1),
    this.decelerationCurve = Curves.easeInOut,
    this.interactive = true,
    this.pauseAfterInteraction = const Duration(seconds: 2)
  })  : assert(text != null, "The Marquee's child cannot be null."),
        assert(scrollAxis != null, "The Marquee's scrollAxis cannot be null."),
        assert(
            blankSpace != null,
            "The Marquee's blankSpace cannot be null. If you don't want any blank "
            "space, set it to 0.0 instead."),
        assert(!blankSpace.isNaN, "The Marquee's blankSpace cannot be NaN."),
        assert(
            blankSpace >= 0, "The Marquee's blankSpace needs to be positive."),
        assert(blankSpace.isFinite,
            "The Marquee's blankSpace needs to be finite."),
        assert(velocity != null, "The Marquee's velocity cannot be null."),
        assert(!velocity.isNaN, "The Marquee's velocity cannot be NaN."),
        assert(
            velocity > 0.0,
            "For now, the Marquee's velocity needs to be positive.\n"
            "Keep the package up to date for further updates, where this may change."),
        assert(velocity.isFinite, "The Marquee's velocity needs to be finite."),
        super(key: key);

  final String text;
  final TextStyle style;

  /// The Marquee's [scrollAxis].
  /// If set to [Axis.horizontal], the Marquee will scroll to the right.
  /// If set to [Axis.vertical], the Marquee will scroll to the bottom.
  final Axis scrollAxis;

  /// The Marquee's [blankSpace], which is displayed between children.
  /// Needs to be >= 0.0 and finite.
  final double blankSpace;

  /// The Marquee's scrolling [velocity] in pixels per second.
  final double velocity;
  final bool pauseOnRoundTrip;
  final Duration accelerationDuration;
  final Curve accelerationCurve;
  final Duration decelerationDuration;
  final Curve decelerationCurve;

  final bool interactive;
  final Duration pauseAfterInteraction;

  @override
  State<StatefulWidget> createState() => _MarqueeState();
}

enum _MarqueeStatus {
  scrolling,
  dragging,
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  _MarqueeStatus status = _MarqueeStatus.scrolling;

  /// The scroll controller that controls the ListView.
  final ScrollController controller = ScrollController();

  /// Next to frames in Flutter, we define super-frames as points in time where
  /// the list is not animating. They usually occur exactly every 100 ms.
  /// The current position in pixels.
  double lastPosition = 0.0;
  double nextPosition = 0.0;

  /// The timer that is fired every second.
  Timer timer;

  @override
  void initState() {
    super.initState();
    /*final animationController = AnimationController(vsync: this, duration: Duration(minutes: 1));
    animationController.addListener(() {
      print('Frame passed');
    });
    animationController.forward();*/

    //timer = Timer.periodic(Duration(milliseconds: 100), (timer) => _tick());
    controller.addListener(_onScroll);
    Future.delayed(Duration.zero, _startScrolling);
    print('State initialized');

    final curve = _IntegralCurve(Curves.easeInOut);
    for (double t = 0.0; t < 1.0; t += 0.01) {
      print('Integral curve of $t is ${curve.transform(t)}. Original of $t is ${Curves.easeInOut.transform(t)}.');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  static double _getCurveIntegral(Curve curve) {
    double integral = 0.0;
    for (double t = 0.0; t < 1.0; t += 0.01) {
      integral += curve.transform(t) * 0.01;
    }
    return integral;
  }

  /// Safely animates the controller to the given position.
  void _animateControllerTo(double position, {
    Duration duration = const Duration(milliseconds: 100),
    Curve curve = Curves.linear
  }) {
    nextPosition = position;
    lastPosition = controller.position.pixels;
    controller.animateTo(nextPosition, duration: duration, curve: curve);
  }

  /// Starts the scrolling (with accelerating).
  void _startScrolling() {
    status = _MarqueeStatus.scrolling;

    if (widget.accelerationDuration > Duration.zero) {
      final positionDelta = _getCurveIntegral(widget.accelerationCurve) * widget.velocity * widget.accelerationDuration.inMilliseconds / 1000;
      print('Position delta is $positionDelta');
      _animateControllerTo(
        lastPosition + positionDelta,
        duration: widget.accelerationDuration,
        curve: _IntegralCurve(widget.accelerationCurve)
      );
    }
    Future.delayed(widget.accelerationDuration, () {
      if (status == _MarqueeStatus.scrolling) {
        timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
          _animateControllerTo(nextPosition + widget.velocity / 10);
        });
      }
    });
  }

  void _onScroll() {
    final pos = controller.position.pixels;

    if (min(lastPosition, nextPosition) <= pos && pos <= max(lastPosition, nextPosition)) {
      //print('Ignoring scroll to $pos.');
      return;
    }

    //print('Scrolled to ${controller.position.pixels} pixels. Calculated scroll position is $position.');
    print('You scrolled! Not: ${min(lastPosition, nextPosition)} <= $pos <= ${max(lastPosition, nextPosition)}');
    timer?.cancel();
    lastPosition = pos;
    nextPosition = pos;
    Future.delayed(widget.pauseAfterInteraction, () {
      if (lastPosition == pos && nextPosition == pos)
        _startScrolling();
    });
  }

  /// Builds the marquee.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      scrollDirection: widget.scrollAxis,
      //physics: NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        return i.isEven ? Text(widget.text, style: widget.style) : _buildBlankSpace();
      }
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
