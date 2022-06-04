## 2.2.3

- Update `fading_edge_scrollview` dependency to `3.0.0`, which supports Flutter 3.
- Thanks to @jannisnikoy

## 2.2.2

- Update to Flutter 3.
- Simplify the readme.
- Strip down example to the essentials.
- Thanks to @ymback

## 2.2.1

- Fix error: ScrollController not attached to any scroll views.
- Thanks to @SergeyShustikov

## 2.2.0

- Add support for right to left languages.
- Thanks to @yanivshaked

## 2.1.0

- Add `onDone` property.
- Fix bug of using the wrong padding and `startPosition` when you delay scrolling.
- Thanks to @Jeferson505 and @emagnier

## 2.0.0

- Migrate to null-safety.
- Thanks to @Konrad97

## 1.7.0

- Add `textScaleFactor` parameter.
- Thanks to @Sprechen

## 1.6.1

- Fixed bug of detached `ScrollController` after `startAfter` duration.
- Improve this changelog.
- Thanks to @Sauceee and @nt4f04uNd

## 1.6.0

- Added `startAfter` argument to start scrolling after a duration.
- Make documentation better.
- Thanks to @hacker1024

## 1.5.3

- Removed fading on the web.
- Thanks to @HardVeur

## 1.5.2

- Fixed the fading flashing even if there is no pause.

## 1.5.1

- Minor fixes.
- Thanks to @arnaudenub

## 1.5.0

- Added feature faded edges.
- Thanks to @arnaudenub

## 1.4.0

- Added support to stop the scroll after a given number of rounds.
- Thanks to @arnaudenub

## 1.3.1

- Minor fixes.
- Thanks to @kodebot and @danieldai

## 1.2.0

- Added support for cross-axis alignment.

## 1.0.0

- Complete overhaul of the widget architecture. Now, no custom widget is
  accepted as a child, but only text. This is a limitation that was consciously
  made to allow several other features to be implemented, including:
  * More efficient scrolling that resets after every round.
  * Backwards scrolling.
  * Pauses after every round.
  * Custom durations and curves for accelerating and decelerating.
- Switched to async handling of scrolling instead of relying on Timer,
  resulting in a more consistent experience when resuming from a paused app
  state.
- Start padding added.
- API documentation greatly improved. Added many examples.
- README is more concise.

## 0.1.0

- Added example.

## 0.0.2

- Improved readme.
- Thanks to @MohiuddinM

## 0.0.1

- Initial release featuring custom `scrollAxis`, `blankSpace`, and `velocity`.
