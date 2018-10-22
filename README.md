# marquee

A Flutter widget that scrolls its child infinitely. Features vertical and horizontal scrolling as well as custom velocities.

*Appreciate the widget? Show some ❤️ and star the repo to support the project.*

## Resources

- [Pub Package](https://pub.dartlang.org/packages/marquee)
- [GitHub Repository](https://github.com/marcelgarus/marquee)

## Usage

The Marquee repeats its child over and over and scrolls it automatically.

```dart
Marquee(
  child: Text('There once was a boy who told this story about a boy: "'),
)
```

### scrollAxis

While normally, the `Marquee` scrolls horizontally, by setting the `scrollAxis`
property to either `Axis.horizontal` or `Axis.vertical`, you can specify the
direction in which the `Marquee` scrolls.

```dart
Marquee(
  scrollAxis: Axis.vertical,
  child: Text("Look what's below this:"),
)
```

### blankSpace

If you want to have some space between the children, there's a `blankSpace`
property you can set:

```dart
Marquee(
  blankSpace: 300.0,
  child: Text('Wait for it...'),
)
```

### velocity

You can also customize the `velocity` the `Marquee` scrolls with. Just set the
`velocity` parameter to any velocity in pixels per second.

```dart
Marquee(
  velocity: 1000.0,
  child: Text('Gotta go faaaaaast...'),
)
```

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
