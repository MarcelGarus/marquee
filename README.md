⏩ A Flutter widget that scrolls text infinitely. Provides many customizations
including custom scroll directions, durations, curves as well as pauses after
every round.

*Appreciate the widget? Show some ❤️ and star the repo to support the project.*

## Usage

This is a minimalistic example:

```dart
Marquee(
  text: 'There once was a boy who told this story about a boy: "',
)
```

And here's a piece of code that makes full use of the marquee's
customizability:

```dart
Marquee(
  text: 'Some sample text that takes some space.',
  style: TextStyle(fontWeight: FontWeight.bold),
  scrollAxis: Axis.horizontal,
  crossAxisAlignment: CrossAxisAlignment.start,
  blankSpace: 20.0,
  velocity: 100.0,
  pauseAfterRound: Duration(seconds: 1),
  startPadding: 10.0,
  accelerationDuration: Duration(seconds: 1),
  accelerationCurve: Curves.linear,
  decelerationDuration: Duration(milliseconds: 500),
  decelerationCurve: Curves.easeOut,
)
```

For more information about the properties, have a look at the
[API reference](https://pub.dartlang.org/documentation/marquee/).
