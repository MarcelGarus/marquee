## [1.0.0] - 2018/10/29

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
* API documentation greatly improved. Many examples added.
* README is more concise.

## [0.1.0] - 2018/10/22

* Added example.

## [0.0.2] - 2018/10/22

* Improved readme.

## [0.0.1] - 2018/10/22

* Initial release featuring custom scrollAxis, blankSpace and velocity.
