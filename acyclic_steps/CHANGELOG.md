## v0.11.0
 * Migrated to null-safety, shouldn't involve any breaking changes.

## v0.10.1
 * Added a workaround for `ArgumentError.checkNotNull` regression in Dart 2.8.1,
   see [dartlang/sdk#41871](https://github.com/dart-lang/sdk/issues/41871).

## v0.10.0
 * **breaking** re-defined API for creating `Step`'s. The new fluent API ensures
   that the `runStep` method will infer correct types from generics. Due to low
   adoption at this point, breaking the package interface was deemed acceptable.

## v0.9.0
 * Initial release.
