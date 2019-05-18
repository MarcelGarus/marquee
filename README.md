# marquee

⏩ A Flutter widget that scrolls text infinitely. Provides many customizations
including custom scroll directions, durations, curves as well as pauses after
every round.

*Appreciate the widget? Show some ❤️ and star the repo to support the project.*

- [Pub Package](https://pub.dartlang.org/packages/marquee)
- [GitHub Repository](https://github.com/marcelgarus/marquee)
- [API reference](https://pub.dartlang.org/documentation/marquee/)

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

## LICENSE

```
Copyright (c) 2018 Marcel Garus

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
