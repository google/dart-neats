## v1.4.2
 * Added `topics` to `pubspec.yaml`.

## v1.4.1
- Deprecating `ChunkedStreamIterator` in favor of
  [`ChunkedStreamReader`](https://pub.dev/documentation/async/latest/async/ChunkedStreamReader-class.html)
  from `package:async` version `^2.6.0`.

## v1.4.0
- Stable null-safety release

## v1.4.0-nullsafety.0
- Added `readByteStream` which uses `BytesBuilder` from `dart:typed_data` under
  the hood.
- Added `readBytes` to `ChunkedStreamIterator<int>` for reading byte streams
  into `Uint8List`.
- Added `@sealed` annotation to all exported classes.

## v1.3.0-nullsafety.0

- Migrated to null safety

## v1.2.0

- Changed `ChunkedStreamIterator` implementation to fix bugs related to
  stream pausing and resuming.

## v1.1.0

- Added `asChunkedStream(N, input)` for wrapping a `Stream<T>` as a
  chunked stream `Stream<List<T>>`, which is useful when batch processing
  chunks of a stream.

## v1.0.1

- Fixed lints reported by pana.

## v1.0.0

- Initial release.
