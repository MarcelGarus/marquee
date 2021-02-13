## [1.7.0] - 2020-09-10

* Add `textScaleFactor` parameter.
* Thanks to @Sprechen

## [1.6.1] - 2020-09-10

* Fixed bug of detached `ScrollController` after `startAfter` duration.
* Improve this changelog.
* Thanks to @Sauceee and @nt4f04uNd

## [1.6.0] - 2020-09-02

* Added `startAfter` argument to start scrolling after a duration.
* Make documentation better.
* Thanks to @hacker1024

## [1.5.3] - 2020-08-22

* Removed fading on the web.
* Thanks to @HardVeur

## [1.5.2] - 2020-06-04

* Fixed the fading flashing even if there is no pause.

## [1.5.1] - 2020-06-04

* Minor fixes.
* Thanks to @arnaudenub

## [1.5.0] - 2020-06-04

* Added feature faded edges.
* Thanks to @arnaudenub

## [1.4.0] - 2020-06-04

* Added support to stop the scroll after a given number of rounds.
* Thanks to @arnaudenub

## [1.3.1] - 2019-09-25

* Minor fixes.
* Thanks to @kodebot and @danieldai

## [1.2.0] - 2019-04-29

* Added support for cross-axis alignment.

## [1.0.0] - 2018-10-29

* Complete overhaul of the widget architecture. Now, no custom widget is
  accepted as a child, but only text. This is a limitation that was consciously
  made to allow several other features to be implemented, including:
  * More efficient scrolling that resets after every round.
  * Backwards scrolling.
  * Pauses after every round.
  * Custom durations and curves for accelerating and decelerating.
* Switched to async handling of scrolling instead of relying on Timer,
  resulting in a more consistent experience when resuming from a paused app
  state.
* Start padding added.
* API documentation greatly improved. Added many examples.
* README is more concise.

## [0.1.0] - 2018-10-22

* Added example.

## [0.0.2] - 2018-10-22

* Improved readme.
* Thanks to @MohiuddinM

## [0.0.1] - 2018-10-22

* Initial release featuring custom `scrollAxis`, `blankSpace`, and `velocity`.
