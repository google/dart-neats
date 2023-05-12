## v3.1.2
 * Make the `RetryOptions` class `final`.

## v3.1.1
 * Add `topics` to pubspec.

## v3.1.0
 * Stable null-safety release.

## v3.1.0-null-safety.0
 * Migrate to null-safety.

## v3.0.1
 * Fix retry overflow

## v3.0.0+1
 * Update the example in `README.md`.

## v3.0.0
 * When `retryIf` is not given, we default to retry any `Exception` thrown.
   This is breaking, but provides a more useful default behavior.

## v2.0.0
 * Expect complete API break.
 * Initial release started from scratch, lifted from code in
   [github.com/dart-lang/pub-dartlang-dart](https://github.com/dart-lang/pub-dartlang-dart).
 * Credits to Tim Kluge for transferring ownership.
 * Dart 2.0 support.

## v1.0.0
 * Initial release by Tim Kluge from 
   [github.com/gwTumm/dart-retry](https://github.com/gwTumm/dart-retry).
