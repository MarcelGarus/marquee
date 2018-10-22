library marquee;

import 'dart:async';
import 'package:flutter/widgets.dart';

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
    @required this.child,
    this.scrollAxis = Axis.horizontal,
    this.blankSpace = 0.0,
    this.velocity = 50.0,
  })  : assert(child != null, "The Marquee's child cannot be null."),
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

  /// The Marquee's [child] that is displayed scrolling by and is rendered
  /// repeatedly.
  final Widget child;

  /// The Marquee's [scrollAxis].
  /// If set to [Axis.horizontal], the Marquee will scroll to the right.
  /// If set to [Axis.vertical], the Marquee will scroll to the bottom.
  final Axis scrollAxis;

  /// The Marquee's [blankSpace], which is displayed between children.
  /// Needs to be >= 0.0 and finite.
  final double blankSpace;

  /// The Marquee's scrolling [velocity] in pixels per second.
  final double velocity;

  @override
  State<StatefulWidget> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  /// The scroll controller that controls the ListView.
  final ScrollController controller = ScrollController();

  /// The current position in pixels.
  double position = 0.0;

  /// The timer that is fired every second.
  Timer timer;

  @override
  void initState() {
    super.initState();
    _startScrolling();
  }

  @override
  void dispose() {
    _stopScrolling();
    super.dispose();
  }

  void _startScrolling() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      position += widget.velocity;

      controller.animateTo(position,
          duration: Duration(seconds: 1), curve: Curves.linear);
    });
  }

  void _stopScrolling() => timer?.cancel();

  /// Builds the marquee.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: controller,
        scrollDirection: widget.scrollAxis,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (_, i) => i.isEven ? widget.child : _buildBlankSpace());
  }

  /// Builds the blank space between children.
  Widget _buildBlankSpace() {
    return SizedBox(
      width: widget.scrollAxis == Axis.horizontal ? widget.blankSpace : null,
      height: widget.scrollAxis == Axis.vertical ? widget.blankSpace : null,
    );
  }
}
